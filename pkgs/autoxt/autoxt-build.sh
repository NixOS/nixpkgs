#! /bin/sh

export NIX_LDFLAGS=-Wl,-s

. $stdenv/setup || exit 1

echo "out: $out"
echo "pwd: `pwd`"
echo "src: $src"
ls $src

cp -r $src autoxt
ls

cd autoxt || exit 1
./bootstrap || exit 1
./configure --prefix=$out || exit 1
make || exit 1
make install || exit 1

