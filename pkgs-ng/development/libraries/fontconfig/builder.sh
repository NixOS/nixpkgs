#! /bin/sh

buildinputs="$freetype $expat $x11 $ed"
. $stdenv/setup || exit 1

# Fontconfig generates a bad `fonts.conf' file is the timezone is not known
# (because it calls `date').
export TZ=UTC

tar xvfz $src || exit 1
cd fontconfig-* || exit 1
./configure --prefix=$out --with-confdir=$out/etc/fonts \
 --x-includes=$x11/include --x-libraries=$x11/lib \
 --with-expat-includes=$expat/include --with-expat-lib=$expat/lib || exit 1
make || exit 1
make install || exit 1

echo "$freetype" > $out/propagated-build-inputs || exit 1
