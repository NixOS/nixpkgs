#! /bin/sh

export PATH=$pkgconfig/bin:/bin:/usr/bin
envpkgs=$glib
. $setenv

tar xvfj $src || exit 1
cd atk-* || exit 1
./configure --prefix=$out || exit 1
make || exit 1
make install || exit 1
echo $envpkgs > $out/envpkgs || exit 1
