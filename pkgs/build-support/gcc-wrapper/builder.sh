. $stdenv/setup


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


mkGccWrapper () {
    local dst=$1
    local src=$2

    if ! test -f "$src"; then
        echo "$src does not exist (skipping)"
        return
    fi

    sed \
        -e "s^@gcc@^$src^g" \
        -e "s^@out@^$out^g" \
        -e "s^@shell@^$shell^g" \
        < $gccWrapper > $dst
    chmod +x $dst
}

mkGccWrapper $out/bin/gcc $gccPath/gcc
ln -s gcc $out/bin/cc

mkGccWrapper $out/bin/g++ $gccPath/g++
ln -s g++ $out/bin/c++

mkGccWrapper $out/bin/g77 $gccPath/g77
ln -s g77 $out/bin/f77


sed \
    -e "s^@out@^$out^g" \
    -e "s^@ldflags@^$ldflags^g" \
    -e "s^@ldflagsBefore@^$ldflagsBefore^g" \
    -e "s^@ld@^$ldPath/ld^g" \
    -e "s^@shell@^$shell^g" \
    < $ldWrapper > $out/bin/ld
chmod +x $out/bin/ld


mkdir $out/nix-support
test -n "$gcc" && echo $gcc > $out/nix-support/orig-gcc
test -n "$glibc" && echo $glibc > $out/nix-support/orig-glibc

cat > $out/nix-support/add-flags <<EOF
export NIX_CFLAGS_COMPILE="$cflagsCompile \$NIX_CFLAGS_COMPILE"
export NIX_CFLAGS_LINK="$cflagsLink \$NIX_CFLAGS_LINK"
export NIX_LDFLAGS="$ldflags \$NIX_LDFLAGS"
export NIX_LDFLAGS_BEFORE="$ldflagsBefore \$NIX_LDFLAGS_BEFORE"
export NIX_GLIBC_FLAGS_SET=1
#export GCC_EXEC_PREFIX=$gcc/libexec/gcc/i686-pc-linux-gnu/3.4.3
EOF

sed \
    -e "s^@gcc@^$gcc^g" \
    -e "s^@binutils@^$binutils^g" \
    -e "s^@glibc@^$glibc^g" \
    < $setupHook > $out/nix-support/setup-hook

cp -p $utils $out/nix-support/utils
