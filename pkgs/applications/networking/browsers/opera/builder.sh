source $stdenv/setup

buildPhase() {
    true
}

installPhase() {
    substituteInPlace install.sh --replace /bin/pwd pwd
    
    # Note: the "no" is because the install scripts asks whether we
    # want to install icons in some system-wide directories.
    echo no | ./install.sh --prefix=$out

    [ -z ${system##*64*} ] && suf=64

    for i in $out/lib/opera/*/opera $out/lib/opera/*/operaplugincleaner $out/lib/opera/*/operapluginwrapper; do
        echo "$i <<<<<<<<<<<<"
        patchelf \
            --set-interpreter "$(cat $NIX_GCC/nix-support/dynamic-linker)" \
            --set-rpath "$libPath" \
            "$i"
    done
    
    # Substitute pwd as late as possible so that the md5 checksum check of opera passes.
    substituteInPlace $out/bin/opera --replace /bin/pwd pwd

    ensureDir $out/share/applications
    cp $desktopItem/share/applications/* $out/share/applications
}

genericBuild
