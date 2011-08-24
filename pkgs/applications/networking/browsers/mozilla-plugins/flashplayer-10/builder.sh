source $stdenv/setup

dontStrip=1
dontPatchELF=1
sourceRoot=$TMPDIR

unpackPhase() {
    tar xvzf $src;
    for a in *; do
	if [ -d $a ]; then
		cd $a
		break
	fi
    done
}

installPhase() {
    ensureDir $out/lib/mozilla/plugins
    cp -pv libflashplayer.so $out/lib/mozilla/plugins
    patchelf --set-rpath "$rpath" $out/lib/mozilla/plugins/libflashplayer.so
}

genericBuild
