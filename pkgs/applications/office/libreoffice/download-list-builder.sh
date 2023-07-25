if [ -e .attrs.sh ]; then source .attrs.sh; fi
source $stdenv/setup

tar --extract --file=$src libreoffice-$version/download.lst -O > $out
