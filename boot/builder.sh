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
        -e "s^@wget\@^$wget^g" \
        -e "s^@which\@^$which^g" \
        -e "s^@subversion\@^$subversion^g" \
        -e "s^@vim\@^$vim^g" \
        -e "s^@screen\@^$screen^g" \
        -e "s^@less\@^$less^g" \
        -e "s^@openssh\@^$openssh^g" \
        -e "s^@binutils\@^$binutils^g" \
        -e "s^@strace\@^$strace^g" \
        -e "s^@shadowutils\@^$shadowutils^g" \
        -e "s^@iputils\@^$iputils^g" \
        -e "s^@gnumake\@^$gnumake^g" \
        -e "s^@curl\@^$curl^g" \
        -e "s^@gnused\@^$gnused^g" \
        -e "s^@gnutar\@^$gnutar^g" \
        -e "s^@gnugrep\@^$gnugrep^g" \
        -e "s^@gzip\@^$gzip^g" \
        -e "s^@gcc\@^$gcc^g" \
        -e "s^@mingetty\@^$mingetty^g" \
        -e "s^@grub\@^$grub^g" \
        -e "s^@udev\@^$udev^g" \
        -e "s^@out\@^$out^g" \
        < $i > $dst
    chmod +x $dst
done
