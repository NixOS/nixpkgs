#! /bin/sh

. $stdenv/setup || exit 1

tar xvfz $src || exit 1
cd zlib-* || exit 1
./configure --prefix=$out --shared || exit 1
make || exit 1
mkdir $out || exit 1
make install || exit 1
