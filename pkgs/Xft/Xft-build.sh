#! /bin/sh

envpkgs="$fontconfig $x11"
. $stdenv/setup || exit 1
export PATH=$pkgconfig/bin:$PATH

tar xvfz $src || exit 1
cd xft-* || exit 1
./configure --prefix=$out --x-includes=$x11/include --x-libraries=$x11/lib || exit 1
make || exit 1
make install || exit 1
echo $envpkgs > $out/envpkgs || exit 1
