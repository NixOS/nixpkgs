source $stdenv/setup


mkdir -p $out/bin
mkdir -p $out/nix-support


if test -z "$nativeLibc"; then
    dynamicLinker="$libc/lib/$dynamicLinker"
    echo $dynamicLinker > $out/nix-support/dynamic-linker

    # The "-B$libc/lib/" flag is a quick hack to force gcc to link
    # against the crt1.o from our own glibc, rather than the one in
    # /usr/lib.  (This is only an issue when using an `impure'
    # compiler/linker, i.e., one that searches /usr/lib and so on.)
    echo "-B$libc/lib/ -isystem $libc/include" > $out/nix-support/libc-cflags
    
    echo "-L$libc/lib" > $out/nix-support/libc-ldflags

    # The dynamic linker is passed in `ldflagsBefore' to allow
    # explicit overrides of the dynamic linker by callers to gcc/ld
    # (the *last* value counts, so ours should come first).
    echo "-dynamic-linker $dynamicLinker" > $out/nix-support/libc-ldflags-before
fi

if test -n "$nativeTools"; then
    gccPath="$nativePrefix/bin"
    ldPath="$nativePrefix/bin"
else
    if test -e "$gcc/lib64"; then
        gccLDFlags="$gccLDFlags -L$gcc/lib64"
    fi
    gccLDFlags="$gccLDFlags -L$gcc/lib"
    echo "$gccLDFlags" > $out/nix-support/gcc-ldflags

    # GCC shows $gcc/lib in `gcc -print-search-dirs', but not
    # $gcc/lib64 (even though it does actually search there...)..
    # This confuses libtool.  So add it to the compiler tool search
    # path explicitly.
    if test -e "$gcc/lib64"; then
        gccCFlags="$gccCFlags -B$gcc/lib64"
    fi
    echo "$gccCFlags" > $out/nix-support/gcc-cflags
    
    gccPath="$gcc/bin"
    ldPath="$binutils/bin"
fi


doSubstitute() {
    local src=$1
    local dst=$2
    # Can't use substitute() here, because replace may not have been
    # built yet (in the bootstrap).
    sed \
        -e "s^@out@^$out^g" \
        -e "s^@shell@^$shell^g" \
        -e "s^@gcc@^$gcc^g" \
        -e "s^@gccProg@^$gccProg^g" \
        -e "s^@binutils@^$binutils^g" \
        -e "s^@libc@^$libc^g" \
        -e "s^@ld@^$ldPath/ld^g" \
        < "$src" > "$dst" 
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

mkGccWrapper $out/bin/upc $gccPath/upc


# Create a symlink to as (the assembler).  This is useful when a
# gcc-wrapper is installed in a user environment, as it ensures that
# the right assembler is called.
ln -s $ldPath/as $out/bin/as


# Make a wrapper around the linker.
doSubstitute "$ldWrapper" "$out/bin/ld"
chmod +x "$out/bin/ld"


# Emit a setup hook.  Also store the path to the original GCC and
# Glibc.
test -n "$gcc" && echo $gcc > $out/nix-support/orig-gcc
test -n "$libc" && echo $libc > $out/nix-support/orig-libc

doSubstitute "$addFlags" "$out/nix-support/add-flags.sh"

doSubstitute "$setupHook" "$out/nix-support/setup-hook"

cp -p $utils $out/nix-support/utils.sh


# Propagate the wrapped gcc so that if you install the wrapper, you get
# tools like gcov, the manpages, etc. as well (including for binutils
# and Glibc).
if test -z "$nativeTools"; then
    echo $gcc $binutils $libc > $out/nix-support/propagated-user-env-packages
fi
