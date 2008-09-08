#! /bin/sh

nohup bash -c 'NIX_REMOTE= ./install-script.sh &>/dev/tty11' &

sleep 1;

chvt 11 || true;

disown 

exit

