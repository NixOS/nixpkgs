buildinputs="$pkgconfig $perl $python $x11 $libgnomeui \
  $libglade $scrollkeeper $esound $gettext $zvbi $libjpeg $libpng"
. $stdenv/setup || exit 1

# !!! hack; this is because $linuxHeaders/config.h includes some
# file autoconf.h.  What is that?
export NIX_CFLAGS_COMPILE="-D_LINUX_CONFIG_H $NIX_CFLAGS_COMPILE"

# Bug: esound is not added to LDFLAGS, and libtool then picks it up from /usr!

tar xvfj $src || exit 1
cd zapping-* || exit 1
LDFLAGS="-L$esound/lib" ./configure --prefix=$out || exit 1
make || exit 1
# !!! hack - it tries to setuid to root
make install ZSFB_OWNER=`id -u` ZSFB_GROUP=`id -g` || exit 1
