#! /bin/sh -e

. $stdenv/setup

mkdir $out
mkdir $out/bin

sed \
    -e "s^@bash\@^$bash^g" \
    -e "s^@coreutils\@^$coreutils^g" \
    -e "s^@findutils\@^$findutils^g" \
    < $src > $out/bin/init

chmod +x $out/bin/init
