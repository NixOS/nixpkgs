#! /bin/sh

buildinputs="$pkgconfig $gtk $gtkspell $gnet $libxml2 $perl"
. $stdenv/setup || exit 1

tar xvfj $src || exit 1
cd pan-* || exit 1
./configure --prefix=$out || exit 1
make || exit 1
make install || exit 1
