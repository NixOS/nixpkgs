buildInputs="$gtk $gdkpixbuf $openssl"
. $stdenv/setup

if test "$sslSupport" = 1; then
    configureFlags="--enable-ssl $configureFlags"
fi

if test "$imageSupport" = 1; then
    configureFlags="--enable-gdk-pixbuf $configureFlags"
else
    configureFlags="--disable-gdk-pixbuf --disable-imlibtest $configureFlags"
fi

genericBuild
