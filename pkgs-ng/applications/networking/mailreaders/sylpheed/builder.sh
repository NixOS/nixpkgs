#! /bin/sh

buildinputs="$gtk $gdkpixbuf $openssl"
. $stdenv/setup || exit 1

if test $sslSupport; then
    extraflags="--enable-ssl $extraflags"
fi

if test $imageSupport; then
    extraflags="--enable-gdk-pixbuf $extraflags"
else
    extraflags="--disable-gdk-pixbuf --disable-imlibtest $extraflags"
fi    

tar xvfj $src || exit 1
cd sylpheed-* || exit 1
./configure --prefix=$out $extraflags || exit 1
make || exit 1
make install || exit 1
