#! /bin/sh

export PATH=$pkgconfig/bin:/bin:/usr/bin
export PKG_CONFIG_PATH=$glib/lib/pkgconfig
export LD_LIBRARY_PATH=$glib/lib

top=`pwd`
tar xvfj $src
cd atk-*
./configure --prefix=$top
make
make install
