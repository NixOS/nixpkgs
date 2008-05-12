#! /bin/sh

nohup bash -c 'NIX_REMOTE= ./install-script.sh &>/dev/tty11' &

disown 

exit

