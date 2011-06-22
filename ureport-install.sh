ureport-admin.py startproject ureport-project
read -p "What name do you want to use for your database? (default is rapidsms)" dbname
if  [ ! -n "$dbname" ] ; then
    dbname=rapidsms
fi
while true; do
    read -p "Which database software do you use? [m]ysql, [p]ostgresql, or [s]qlite (default is sqlite)" db
    if [ ! -n "$db" ] ; then
        db=s
    fi
    case $db in
        [Mm]*  ) engine="django.db.backends.mysql" ;
                 user="mysql"
                 mysql < echo create database $dbname; 
                 break;;
        [Pp]*  ) engine="django.db.backends.postgresql_psycopg2" ;
                 user="postgres"
                 createdb $dbname; 
                 break;;
        [Ss]*  ) engine="django.db.backends.sqlite3"
    esac
done
read -p "Enter your clickatell api id: " api
read -p "Enter your clickatell user name: " user
read -p "Enter your clickatell password: " password
sed -e 's/django\.db\.backends\.postgresql_psycopg2/'"$engine"'/' \
    -e 's/rapidsmsdb/'"$dbname"'/' \
    -e 's/dbuser/'"$user"'/' \
    -e 's/CLICKAPI/'"$api"'/' \
    -e 's/CLICKUSER/'"$user"'/' \
    -e 's/CLICKPASS/'"$password"'/' \
    < ureport-project/settings.py > ureport-project/settings_tweaked.py
cd ureport-project
python manage.py syncdb
python manage.py runserver

