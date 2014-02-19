FROM ubuntu
MAINTAINER supermomonga

RUN locale-gen en_US.UTF-8
RUN update-locale LANG=en_US.UTF-8
env LC_ALL C
env LC_ALL en_US.UTF-8

# RUN echo "deb http://archive.ubuntu.com/ubuntu precise main universe" > /etc/apt/sources.list
RUN apt-get update
RUN apt-get -y upgrade


# Basic Requirements
RUN apt-get -y install nginx php-apc pwgen curl git unzip postgresql

# EC-CUBE Requirements
RUN apt-get -y install php5 libapache2-mod-php5 php5-json php5-pgsql php5-gd php5-mhash php5-mcrypt php5-curl php5-intl php-pear php5-imagick php5-imap php5-memcache php5-ming php5-ps php5-pspell php5-recode php5-snmp php5-sqlite php5-tidy php5-xmlrpc php5-xsl

# nginx config
RUN sed -i -e"s/keepalive_timeout\s*65/keepalive_timeout 2/" /etc/nginx/nginx.conf
RUN sed -i -e"s/keepalive_timeout 2/keepalive_timeout 2;\n\tclient_max_body_size 100m/" /etc/nginx/nginx.conf
RUN echo "daemon off;" >> /etc/nginx/nginx.conf

# nginx site conf
# ADD ./nginx-site.conf /etc/nginx/sites-available/default

# Install EC-CUBE
ADD http://downloads.ec-cube.net/src/eccube-2.13.1.tar.gz /ec-cube.tar.gz
RUN tar xvzf /ec-cube.tar.gz -C /usr/share/nginx
RUN mv /usr/share/nginx/www/5* /usr/share/nginx/ec-cube
RUN rm -rf /usr/share/nginx/www
RUN mv /usr/share/nginx/ec-cube /usr/share/nginx/www
RUN chown -R www-data:www-data /usr/share/nginx/www


RUN apt-get install -y openssh-server
RUN mkdir /var/run/sshd
RUN bash -c 'echo "root:root" | chpasswd'

EXPOSE 80


CMD /usr/sbin/sshd -D
EXPOSE 22

# EXPOSE 21
# EXPOSE 443

