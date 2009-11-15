source $stdenv/setup


# Force gcc to use ld-wrapper.sh when calling ld.
cflagsCompile="-B$out/bin/"

if test -z "$nativeLibc"; then
    cflagsCompile="$cflagsCompile -B$libc/lib/ -isystem $libc/include"
    ldflags="$ldflags -L$libc/lib"
    ldflagsBefore="-dynamic-linker $libc/lib/ld-linux.so.?"
    #ldflagsBefore="-dynamic-linker $libc/lib/ld-uClibc.so.0"
fi

if test -n "$nativeTools"; then
    gccPath="$nativePrefix/bin"
    ldPath="$nativePrefix/bin"
else
    ldflags="$ldflags -L$gcc/lib"
    gccPath="$gcc/bin"
    ldPath="$binutils/bin"
fi


mkdir $out
mkdir $out/bin
mkdir $out/nix-support


doSubstitute() {
    local src=$1
    local dst=$2
    substitute "$src" "$dst" \
        --subst-var "out" \
        --subst-var "shell" \
        --subst-var "gcc" \
        --subst-var "gccProg" \
        --subst-var "binutils" \
        --subst-var "libc" \
        --subst-var "cflagsCompile" \
        --subst-var "cflagsLink" \
        --subst-var "ldflags" \
        --subst-var "ldflagsBefore" \
        --subst-var-by "ld" "$ldPath/ld"
}


# Make wrapper scripts around gcc, g++, and g77.  Also make symlinks
# cc, c++, and f77.
mkGccWrapper() {
    local dst=$1
    local src=$2

    if ! test -f "$src"; then
        echo "$src does not exist (skipping)"
        return
    fi

    gccProg="$src"
    doSubstitute "$gccWrapper" "$dst"
    chmod +x "$dst"
}

mkGccWrapper $out/bin/$cross-gcc $gccPath/$cross-gcc
#ln -s gcc $out/bin/cc

mkGccWrapper $out/bin/g++ $gccPath/g++
ln -s g++ $out/bin/c++

mkGccWrapper $out/bin/g77 $gccPath/g77
ln -s g77 $out/bin/f77

ln -s $binutils/bin/$cross-ar $out/bin/$cross-ar
ln -s $binutils/bin/$cross-as $out/bin/$cross-as
ln -s $binutils/bin/$cross-nm $out/bin/$cross-nm
ln -s $binutils/bin/$cross-strip $out/bin/$cross-strip


# Make a wrapper around the linker.
doSubstitute "$ldWrapper" "$out/bin/$cross-ld"
chmod +x "$out/bin/$cross-ld"


# Emit a setup hook.  Also store the path to the original GCC and
# Glibc.
test -n "$gcc" && echo $gcc > $out/nix-support/orig-gcc
test -n "$libc" && echo $libc > $out/nix-support/orig-libc

doSubstitute "$addFlags" "$out/nix-support/add-flags"

doSubstitute "$setupHook" "$out/nix-support/setup-hook"

cp -p $utils $out/nix-support/utils
