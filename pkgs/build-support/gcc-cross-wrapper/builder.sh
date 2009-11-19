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
        --subst-var-by "ld" "$ldPath/$crossConfig-ld"
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

mkGccWrapper $out/bin/$crossConfig-gcc $gccPath/$crossConfig-gcc
#ln -s gcc $out/bin/cc

mkGccWrapper $out/bin/$crossConfig-g++ $gccPath/$crossConfig-g++
ln -s $crossConfig-g++ $out/bin/$crossConfig-c++

mkGccWrapper $out/bin/$crossConfig-g77 $gccPath/$crossConfig-g77
ln -s $crossConfig-g77 $out/bin/$crossConfig-f77

ln -s $binutils/bin/$crossConfig-ar $out/bin/$crossConfig-ar
ln -s $binutils/bin/$crossConfig-as $out/bin/$crossConfig-as
ln -s $binutils/bin/$crossConfig-nm $out/bin/$crossConfig-nm
ln -s $binutils/bin/$crossConfig-strip $out/bin/$crossConfig-strip


# Make a wrapper around the linker.
doSubstitute "$ldWrapper" "$out/bin/$crossConfig-ld"
chmod +x "$out/bin/$crossConfig-ld"


# Emit a setup hook.  Also store the path to the original GCC and
# Glibc.
test -n "$gcc" && echo $gcc > $out/nix-support/orig-gcc
test -n "$libc" && echo $libc > $out/nix-support/orig-libc

doSubstitute "$addFlags" "$out/nix-support/add-flags"

doSubstitute "$setupHook" "$out/nix-support/setup-hook"

cp -p $utils $out/nix-support/utils
