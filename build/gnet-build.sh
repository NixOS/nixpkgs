#! /bin/sh

export PATH=$pkgconfig/bin:/bin:/usr/bin
export PKG_CONFIG_PATH=$glib/lib/pkgconfig
export LD_LIBRARY_PATH=$glib/lib

top=`pwd`
tar xvfz $src || exit 1
cd gnet-* || exit 1
./configure --prefix=$top || exit 1
make || exit 1
make install || exit 1
cd $top || exit 1
rm -rf gnet-* || exit 1
