#! /bin/sh

export PATH=$pkgconfig/bin:$gnet/bin:/bin:/usr/bin
export PKG_CONFIG_PATH=$glib/lib/pkgconfig:$atk/lib/pkgconfig:$pango/lib/pkgconfig:$gtk/lib/pkgconfig
export LD_LIBRARY_PATH=$glib/lib:$atk/lib:$pango/lib:$gtk/lib:$gnet/lib

top=`pwd`
tar xvfj $src
cd pan-*
./configure --prefix=$top
make
make install
