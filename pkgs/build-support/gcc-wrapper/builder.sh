. $stdenv/setup
. $substitute


# Force gcc to use ld-wrapper.sh when calling ld.
cflagsCompile="-B$out/bin"

if test -z "$nativeGlibc"; then
    # The "-B$glibc/lib" flag is a quick hack to force gcc to link
    # against the crt1.o from our own glibc, rather than the one in
    # /usr/lib.  The real solution is of course to prevent those paths
    # from being used by gcc in the first place.
    # The dynamic linker is passed in `ldflagsBefore' to allow
    # explicit overrides of the dynamic linker by callers to gcc/ld
    # (the *last* value counts, so ours should come first).
    cflagsCompile="$cflagsCompile -B$glibc/lib -isystem $glibc/include"
    ldflags="$ldflags -L$glibc/lib"
    ldflagsBefore="-dynamic-linker $glibc/lib/ld-linux.so.2"
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
        --subst-var "glibc" \
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

mkGccWrapper $out/bin/gcc $gccPath/gcc
ln -s gcc $out/bin/cc

mkGccWrapper $out/bin/g++ $gccPath/g++
ln -s g++ $out/bin/c++

mkGccWrapper $out/bin/g77 $gccPath/g77
ln -s g77 $out/bin/f77


# Make a wrapper around the linker.
doSubstitute "$ldWrapper" "$out/bin/ld"
chmod +x "$out/bin/ld"


# Emit a setup hook.  Also store the path to the original GCC and
# Glibc.
test -n "$gcc" && echo $gcc > $out/nix-support/orig-gcc
test -n "$glibc" && echo $glibc > $out/nix-support/orig-glibc

doSubstitute "$addFlags" "$out/nix-support/add-flags"

doSubstitute "$setupHook" "$out/nix-support/setup-hook"

cp -p $utils $out/nix-support/utils
