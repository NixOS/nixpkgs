. $stdenv/setup

dontBuild=1
dontMakeInstall=1

postInstall=postInstall
postInstall() {
    mkdir -p $out/lib/mozilla/plugins
    cp -p flashplayer.xpt libflashplayer.so $out/lib/mozilla/plugins
    echo "$zlib/lib:$libXmu/lib" > $out/lib/mozilla/plugins/extra-library-path
}

genericBuild
