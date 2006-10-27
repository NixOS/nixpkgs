source $stdenv/setup

buildPhase=buildPhase
buildPhase() {
    true
}

installPhase=installPhase
installPhase() {
    # Note: the "no" is because the install scripts asks whether we
    # want to install icons in some system-wide directories.
    echo no | ./install.sh --prefix=$out

    rpath=/no-such-path
    for i in $libPath; do
        rpath="$rpath:$i/lib"
    done

    # !!! ugh, should fix this eventually; just make a normal gcc dependency
    gcc=$(cat $NIX_GCC/nix-support/orig-gcc)
    rpath="$rpath:$gcc/lib"
    
    for i in $out/lib/opera/*/opera $out/lib/opera/plugins/opera*; do
        patchelf \
            --set-interpreter "$(cat $NIX_GCC/nix-support/dynamic-linker)" \
            --set-rpath "$rpath" \
            "$i"
    done
}

genericBuild
