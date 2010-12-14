source $stdenv/setup

buildPhase() {
    true
}

installPhase() {
    substituteInPlace install --replace /bin/pwd pwd
    substituteInPlace install --replace /usr/local "$out"
    
    # Note: the "no" is because the install scripts asks whether we
    # want to install icons in some system-wide directories.
    
    ensureDir "$out"

    ./install --text --system

    [ -z ${system##*64*} ] && suf=64

    find $out -type f | while read f; do
      echo testing "$f"
      # patch all executables
      if readelf -h "$f" | grep 'EXEC (Executable file)' &> /dev/null; then
        echo "patching $f <<"
        patchelf \
            --set-interpreter "$(cat $NIX_GCC/nix-support/dynamic-linker)" \
            --set-rpath "$libPath" \
            "$f"
      fi
    done
    
    # Substitute pwd as late as possible so that the md5 checksum check of opera passes.
    substituteInPlace $out/bin/opera --replace /bin/pwd pwd

    ensureDir $out/share/applications
    cp $desktopItem/share/applications/* $out/share/applications
}

genericBuild
