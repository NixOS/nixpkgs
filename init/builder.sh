#! /bin/sh -e

. $stdenv/setup

mkdir $out
mkdir $out/bin

sed \
    -e "s^@bash\@^$bash^g" \
    -e "s^@coreutils\@^$coreutils^g" \
    -e "s^@findutils\@^$findutils^g" \
    -e "s^@utillinux\@^$utillinux^g" \
    -e "s^@sysvinit\@^$sysvinit^g" \
    -e "s^@e2fsprogs\@^$e2fsprogs^g" \
    -e "s^@nix\@^$nix^g" \
    < $src > $out/bin/init

chmod +x $out/bin/init
