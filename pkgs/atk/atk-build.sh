#! /bin/sh

. $stdenv/setup || exit 1

export PATH=$pkgconfig/bin:$PATH
envpkgs=$glib
. $setenv

tar xvfj $src || exit 1
cd atk-* || exit 1
LDFLAGS=-Wl,-S ./configure --prefix=$out || exit 1
make || exit 1
make install || exit 1
echo $envpkgs > $out/envpkgs || exit 1
