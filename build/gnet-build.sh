#! /bin/sh

export PATH=$pkgconfig/bin:/bin:/usr/bin
export PKG_CONFIG_PATH=$glib/lib/pkgconfig
export LD_LIBRARY_PATH=$glib/lib

top=`pwd`
tar xvfz $src
cd gnet-*
./configure --prefix=$top
make
make install
cd ..
rm -rf gnet-*
