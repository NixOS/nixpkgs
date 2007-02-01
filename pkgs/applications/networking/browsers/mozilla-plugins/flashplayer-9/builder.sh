source $stdenv/setup

buildPhase=true

installCommand=myInstall
myInstall() {
    mkdir -p $out/lib/mozilla/plugins
    cp -p libflashplayer.so $out/lib/mozilla/plugins
    echo "$zlib/lib:$alsaLib/lib" > $out/lib/mozilla/plugins/extra-library-path
}

genericBuild
