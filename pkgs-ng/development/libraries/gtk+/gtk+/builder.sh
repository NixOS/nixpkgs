#! /bin/sh

buildinputs="$pkgconfig $x11 $glib $atk $pango $perl $libtiff $libjpeg $libpng"
. $stdenv/setup || exit 1

tar xvfj $src || exit 1
cd gtk+-* || exit 1
./configure --prefix=$out --x-includes=$x11/include --x-libraries=$x11/lib \
 --with-libtiff=$tiff || exit 1
make || exit 1
make install || exit 1

echo "$x11 $glib $atk $pango" > $out/propagated-build-inputs || exit 1
