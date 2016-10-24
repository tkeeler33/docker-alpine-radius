FROM alpine:3.1
MAINTAINER Marcel Maatkamp <m.maatkamp@gmail.com>

WORKDIR /projects

RUN apk update && apk upgrade && \
    apk add --update freeradius freeradius-sqlite freeradius-radclient sqlite openssl-dev && \
    chgrp radius  /usr/sbin/radiusd && chmod g+rwx /usr/sbin/radiusd && \
    rm /var/cache/apk/*

VOLUME \
    /opt/db/ \
    /etc/freeradius/certs

EXPOSE \
    1812/udp \
    1813 \
    18120

RUN echo 'echo "$USERNAME Cleartext-Password := \"$PASSWORD\"" > /etc/raddb/users'>start_radius.sh && \
	echo 'echo -e "client $DEVICE_NAME {\n ipaddr = $DEVICE_HOSTNAME\n secret = $DEVICE_SECRET\n}" > /etc/raddb/clients.conf'>>start_radius.sh && \
	echo 'radiusd -f -X'>>start_radius.sh && \
	chmod +x start_radius.sh

CMD ./start_radius.sh
