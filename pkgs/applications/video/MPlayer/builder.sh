. $stdenv/setup

postUnpack() {
    unpackFile $fonts
}
postUnpack=postUnpack

configureFlags="\
 --with-win32libdir=$win32codecs \
 --with-reallibdir=$win32codecs \
 --enable-runtime-cpudetection"

postInstall() {
    cp -p ../font-arial-iso-8859-1/font-arial-18-iso-8859-1/* $out/share/mplayer/font
}
postInstall=postInstall

genericBuild
