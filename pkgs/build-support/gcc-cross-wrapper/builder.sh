source $stdenv/setup

mkdir $out
mkdir $out/bin
mkdir $out/nix-support

# Force gcc to use ld-wrapper.sh when calling ld.
cflagsCompile="-B$out/bin/"

if test -z "$nativeLibc"; then
    cflagsCompile="$cflagsCompile -B$gccLibs/lib -B$libc/lib/ -isystem $libc/include"
    ldflags="$ldflags -L$libc/lib"
    # Get the proper dynamic linker for glibc and uclibc. 
    dlinker=`eval 'echo $libc/lib/ld*.so.?'`
    if [ -n "$dynamicLinker" ]; then
      ldflagsBefore="-dynamic-linker $dlinker"
    fi
    # This trick is to avoid dependencies on the cross-toolchain gcc
    # for libgcc, libstdc++, ...
    # -L is for libtool's .la files, and -rpath for the usual fixupPhase
    # shrinking rpaths.
    if [ -n "$gccLibs" ]; then
      ldflagsBefore="$ldflagsBefore -rpath $gccLibs/lib"
    fi

    # The same as above, but put into files, useful for the gcc builder.
    dynamicLinker="$libc/lib/$dynamicLinker"
    echo $dynamicLinker > $out/nix-support/dynamic-linker

    if test -e $libc/lib/32/ld-linux.so.2; then
        echo $libc/lib/32/ld-linux.so.2 > $out/nix-support/dynamic-linker-m32
    fi

    echo "$cflagsCompile -B$libc/lib/ -idirafter $libc/include -idirafter $gcc/lib/gcc/*/*/include-fixed" > $out/nix-support/libc-cflags

    echo "-L$libc/lib" > $out/nix-support/libc-ldflags

    # The dynamic linker is passed in `ldflagsBefore' to allow
    # explicit overrides of the dynamic linker by callers to gcc/ld
    # (the *last* value counts, so ours should come first).
    echo "$ldflagsBefore" > $out/nix-support/libc-ldflags-before
fi

if test -n "$nativeTools"; then
    gccPath="$nativePrefix/bin"
    ldPath="$nativePrefix/bin"
else
    ldflags="$ldflags -L$gcc/lib -L$gcc/lib64"
    gccPath="$gcc/bin"
    ldPath="$binutils/$crossConfig/bin"
fi


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
        --subst-var "ldPath" \
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
