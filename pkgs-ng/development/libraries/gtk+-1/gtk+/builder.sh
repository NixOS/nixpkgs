#! /bin/sh

buildinputs="$x11 $glib"
. $stdenv/setup || exit 1

tar xvfz $src || exit 1
cd gtk+-* || exit 1
./configure --prefix=$out --x-includes=$x11/include --x-libraries=$x11/lib || exit 1
make || exit 1
make install || exit 1

echo "$x11 $glib" > $out/propagated-build-inputs || exit 1
