source $stdenv/setup

buildPhase=buildPhase
buildPhase() {
    true
}

installPhase=installPhase
installPhase() {
    sed -i 's=/bin/pwd=pwd=' opera install.sh 
    # Note: the "no" is because the install scripts asks whether we
    # want to install icons in some system-wide directories.
    echo no | ./install.sh --prefix=$out

    rpath=/no-such-path
    for i in $libPath; do
        rpath="$rpath:$i/lib"
    done

    [ -z ${system##*64*} ] && suf=64

    # !!! ugh, should fix this eventually; just make a normal gcc dependency
    gcc=$(cat $NIX_GCC/nix-support/orig-gcc)
    rpath="$rpath:$libstdcpp5/lib$suf"
    
    for i in $out/lib/opera/*/opera $out/lib/opera/*/operaplugin{wrapper,cleaner}; do
        patchelf \
            --set-interpreter "$(cat $NIX_GCC/nix-support/dynamic-linker)" \
            --set-rpath "$rpath" \
            "$i"
    done
}

genericBuild
