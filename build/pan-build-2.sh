#! /bin/sh

export PATH=$pkgconfig/bin:$gnet/bin:/bin:/usr/bin
export PKG_CONFIG_PATH=$glib/lib/pkgconfig:$atk/lib/pkgconfig:$pango/lib/pkgconfig:$gtk/lib/pkgconfig:$gtkspell/lib/pkgconfig
export LD_LIBRARY_PATH=$glib/lib:$atk/lib:$pango/lib:$gtk/lib:$gnet/lib:$pspell/lib:$gtkspell/lib

# A bug in gtkspell: the pspell library path is not exported
# through pkgconfig.
export LIBRARY_PATH=$pspell/lib

export LDFLAGS=-s

top=`pwd`
tar xvfj $src
cd pan-*
./configure --prefix=$top
make
make install
cd ..
rm -rf pan-*
