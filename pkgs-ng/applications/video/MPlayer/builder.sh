#! /bin/sh

buildinputs="$freetype $x11 $alsa"
. $stdenv/setup || exit 1

tar xvfj $src || exit 1
tar xvfj $fonts || exit 1
cd MPlayer-* || exit 1
./configure --prefix=$out --with-win32libdir=$win32codecs \
 --with-x11incdir=$x11/include --with-x11libdir=$x11/lib \
 --with-reallibdir=$win32codecs \
 --disable-sdl --disable-esd --disable-xanim --disable-cdparanoia --disable-directfb \
 --disable-lirc --disable-svga --disable-libdv \
 --disable-vorbis --disable-png --disable-jpeg --disable-gif \
 --enable-runtime-cpudetection \
 || exit 1
make || exit 1
make install || exit 1
cp -p ../font-arial-iso-8859-1/font-arial-18-iso-8859-1/* $out/share/mplayer/font || exit 1
