. $stdenv/setup


# Force gcc to use ld-wrapper.sh when calling ld.
cflagsCompile="-B$out/bin"

if test -z "$nativeGlibc"; then
    # The "-B$glibc/lib" flag is a quick hack to force gcc to link
    # against the crt1.o from our own glibc, rather than the one in
    # /usr/lib.  The real solution is of course to prevent those paths
    # from being used by gcc in the first place.
    cflagsCompile="$cflagsCompile -B$glibc/lib -isystem $glibc/include"
    ldflags="$ldflags -L$glibc/lib -rpath $glibc/lib -dynamic-linker $glibc/lib/ld-linux.so.2"
fi

if test -n "$nativeTools"; then
    gccPath="$nativePrefix/bin"
    ldPath="$nativePrefix/bin"
else
    ldflags="$ldflags -L$gcc/lib -rpath $gcc/lib"
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
    -e "s^@ld@^$ldPath/ld^g" \
    < $ldWrapper > $out/bin/ld
chmod +x $out/bin/ld


mkdir $out/nix-support
test -n "$gcc" && echo $gcc > $out/nix-support/orig-gcc
test -n "$glibc" && echo $glibc > $out/nix-support/orig-glibc

cat > $out/nix-support/add-flags <<EOF
NIX_CFLAGS_COMPILE="$cflagsCompile \$NIX_CFLAGS_COMPILE"
NIX_CFLAGS_LINK="$cflagsLink \$NIX_CFLAGS_LINK"
NIX_LDFLAGS="$ldflags \$NIX_LDFLAGS"
EOF

sed \
    -e "s^@gcc@^$gcc^g" \
    -e "s^@binutils@^$binutils^g" \
    -e "s^@glibc@^$glibc^g" \
    < $setupHook > $out/nix-support/setup-hook

cp -p $utils $out/nix-support/utils
