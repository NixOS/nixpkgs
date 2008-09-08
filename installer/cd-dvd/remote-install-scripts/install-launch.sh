#! /bin/sh

stop dhclient
ifconfig eth0 10.0.253.250 netmask 255.255.0.0 up

chmod a+x install-script.sh install-start.sh
scp -i id_livedvd -o StrictHostKeyChecking=no install-script.sh 10.0.253.251: 
scp -i id_livedvd -o StrictHostKeyChecking=no install-start.sh 10.0.253.251: 
ssh -i id_livedvd -o StrictHostKeyChecking=no 10.0.253.251 bash ./install-start.sh 

