#! /bin/sh

export PATH=$pkgconfig/bin:/bin:/usr/bin
export PKG_CONFIG_PATH=$glib/lib/pkgconfig:$atk/lib/pkgconfig:$pango/lib/pkgconfig
export LD_LIBRARY_PATH=$glib/lib:$atk/lib:$pango/lib

top=`pwd`
tar xvfj $src
cd gtk+-*
./configure --prefix=$top
make
make install
