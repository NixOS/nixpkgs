#! /bin/sh

buildinputs="$pkgconfig $glib $lex $yacc"
. $stdenv/setup || exit 1

tar xvfj $src || exit 1
cd libIDL-* || exit 1
./configure --prefix=$out || exit 1
make || exit 1
make install || exit 1
strip -S $out/lib/*.a || exit 1
