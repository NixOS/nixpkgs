#! /bin/sh

export PATH=$pkgconfig/bin:/bin:/usr/bin
export PKG_CONFIG_PATH=$glib/lib/pkgconfig:$atk/lib/pkgconfig:$pango/lib/pkgconfig:$gtk/lib/pkgconfig
export LD_LIBRARY_PATH=$glib/lib:$atk/lib:$pango/lib:$gtk/lib:$pspell/lib
export C_INCLUDE_PATH=$pspell/include

top=`pwd`
tar xvfz $src || exit 1
cd gtkspell-* || exit 1
./configure --prefix=$top || exit 1
make || exit 1
make install || exit 1
cd $top || exit 1
rm -rf gtkspell-* || exit 1
