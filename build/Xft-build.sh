#! /bin/sh

export PATH=$freetype/bin:$fontconfig/bin:/bin:/usr/bin

top=`pwd`
tar xvfz $src || exit 1
cd fcpackage*/Xft || exit 1
./configure --prefix=$top --x-includes=/usr/X11/include --x-libraries=/usr/X11/lib || exit 1
make || exit 1
make install || exit 1
cd $top || exit 1
rm -rf fcpackage* || exit 1
