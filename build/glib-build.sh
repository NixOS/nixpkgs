#! /bin/sh

export PATH=$pkgconfig/bin:/bin:/usr/bin

top=`pwd`
tar xvfj $src
cd glib-*
./configure --prefix=$top
make
make install
cd ..
rm -rf glib-*
