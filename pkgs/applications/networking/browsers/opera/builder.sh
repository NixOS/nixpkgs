source $stdenv/setup

buildPhase() {
    true
}

installPhase() {
  set -x

    sed -i 's=/bin/pwd=pwd=' install.sh 
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
    
    for i in $out/lib/opera/*/opera $out/lib/opera/*/operaplugincleaner; do
        [ -h "$i" ] && i=$(readline "$i")
        echo "$i <<<<<<<<<<<<"
        patchelf \
            --set-interpreter "$(cat $NIX_GCC/nix-support/dynamic-linker)" \
            --set-rpath "$rpath" \
            "$i"
    done
    # substitute pwd as late as possible so that the md5 checkusm check of opera passes
    sed -i 's=/bin/pwd=pwd=' $out/bin/opera
}

genericBuild
