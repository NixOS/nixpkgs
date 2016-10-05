source $stdenv/setup

tar --extract --file=$src libreoffice-$version/download.lst -O > $out
