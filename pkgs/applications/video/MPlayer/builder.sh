source $stdenv/setup

# !!! Remove eventually.
export _POSIX2_VERSION=199209

postUnpack() {
    unpackFile $fonts
}
postUnpack=postUnpack

configureFlags="\
 --with-win32libdir=$win32codecs \
 --with-reallibdir=$win32codecs \
 --enable-runtime-cpudetection \
 --enable-x11 --with-x11incdir=/no-such-dir --with-x11libdir=/no-such-dir
 $configureFlags"

postInstall() {
    cp -p ../font-arial-iso-8859-1/font-arial-18-iso-8859-1/* $out/share/mplayer/font
}
postInstall=postInstall

genericBuild
