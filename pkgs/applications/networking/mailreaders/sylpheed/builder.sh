#! /bin/sh -e

buildInputs="$gtk $gdkpixbuf $openssl"
. $stdenv/setup

if test $sslSupport; then
    configureFlags="--enable-ssl $extraflags"
fi

if test $imageSupport; then
    configureFlags="--enable-gdk-pixbuf $extraflags"
else
    configureFlags="--disable-gdk-pixbuf --disable-imlibtest $extraflags"
fi

genericBuild
