#! /bin/sh

export PATH=/bin:/usr/bin
envpkgs=$fontconfig
. $setenv

tar xvfz $src || exit 1
cd fcpackage*/Xft || exit 1
./configure --prefix=$out --x-includes=/usr/X11/include --x-libraries=/usr/X11/lib || exit 1
make || exit 1
make install || exit 1
echo $envpkgs > $out/envpkgs || exit 1
