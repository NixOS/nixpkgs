#! /bin/sh

export PATH=$pkgconfig/bin:/bin:/usr/bin
export PKG_CONFIG_PATH=$glib/lib/pkgconfig:$atk/lib/pkgconfig:$pango/lib/pkgconfig:$gtk/lib/pkgconfig
export LD_LIBRARY_PATH=$glib/lib:$atk/lib:$pango/lib:$gtk/lib:$pspell/lib
export C_INCLUDE_PATH=$pspell/include

top=`pwd`
tar xvfz $src
cd gtkspell-*
./configure --prefix=$top
make
make install
cd ..
rm -rf gtkspell-*
