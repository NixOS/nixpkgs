#! /bin/sh -e

. $stdenv/setup

mkdir $out
mkdir $out/bin

for i in $boot $halt $login $env; do
    dst=$out/bin/$(basename $i | cut -c34-)
    sed \
        -e "s^@bash\@^$bash^g" \
        -e "s^@coreutils\@^$coreutils^g" \
        -e "s^@findutils\@^$findutils^g" \
        -e "s^@utillinux\@^$utillinux^g" \
        -e "s^@sysvinit\@^$sysvinit^g" \
        -e "s^@e2fsprogs\@^$e2fsprogs^g" \
        -e "s^@nettools\@^$nettools^g" \
        -e "s^@nix\@^$nix^g" \
        -e "s^@out\@^$out^g" \
        < $i > $dst
    chmod +x $dst
done
