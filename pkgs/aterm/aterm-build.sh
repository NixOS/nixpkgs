#! /bin/sh

. $stdenv/setup || exit 1

tar xvfz $src || exit 1
cd aterm-* || exit 1
./configure --prefix=$out || exit 1
make || exit 1
make install || exit 1
(cd $out/lib && ln -s libATerm.a libATerm-gcc.a) || exit 1
