#! /bin/sh

buildinputs="$x11 $wxGTK $libdvdcss $libdvdread $libdvdplay $mpeg2dec $a52dec $libmad $alsa"
. $stdenv/setup || exit 1

tar xvfz $src || exit 1
cd vlc-* || exit 1
./configure --prefix=$out \
 --disable-ffmpeg \
 --enable-alsa \
 || exit 1
make || exit 1
make install || exit 1
