#! /bin/sh

export PATH=$pkgconfig/bin:/bin:/usr/bin
export PKG_CONFIG_PATH=$glib/lib/pkgconfig:$atk/lib/pkgconfig:$pango/lib/pkgconfig:$gtk/lib/pkgconfig
export LD_LIBRARY_PATH=$glib/lib:$atk/lib:$pango/lib:$gtk/lib:$pspell/lib:$fontconfig/lib:$Xft/lib:$freetype/lib

top=`pwd`
tar xvfz $src || exit 1
cd wxPythonSrc-* || exit 1
./configure --prefix=$top --enable-gtk2 --enable-rpath=$top/lib --with-opengl || exit 1
make || exit 1
make install || exit 1
cd wxPython || exit 1
python setup.py WX_CONFIG=$top/bin/wx-config WXPORT=gtk2 build install --root=$top/python || exit 1
cd $top || exit 1
rm -rf wxPythonSrc-* || exit 1
