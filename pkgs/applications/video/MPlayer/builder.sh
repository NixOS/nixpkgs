buildInputs="$x11 $freetype $zlib $alsa"
. $stdenv/setup

postUnpack() {
    unpackFile $fonts
}
postUnpack=postUnpack

configureFlags="\
 --with-win32libdir=$win32codecs \
 --with-reallibdir=$win32codecs \
 --disable-sdl --disable-esd --disable-xanim --disable-cdparanoia --disable-directfb \
 --disable-lirc --disable-svga --disable-libdv \
 --disable-vorbis --disable-png --disable-jpeg --disable-gif \
 --enable-runtime-cpudetection"

postInstall() {
    cp -p ../font-arial-iso-8859-1/font-arial-18-iso-8859-1/* $out/share/mplayer/font
}
postInstall=postInstall

genericBuild
