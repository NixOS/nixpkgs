#! /bin/sh

export PATH=$pkgconfig/bin:/bin:/usr/bin
export PKG_CONFIG_PATH=$glib/lib/pkgconfig:$atk/lib/pkgconfig:$pango/lib/pkgconfig
export LD_LIBRARY_PATH=$glib/lib:$atk/lib:$pango/lib

top=`pwd`
tar xvfj $src || exit 1
cd gtk+-* || exit 1
./configure --prefix=$top || exit 1
make || exit 1
make install || exit 1
cd $top || exit 1
rm -rf gtk+-* || exit 1
