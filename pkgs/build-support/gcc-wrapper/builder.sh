#! /bin/sh -e

. $stdenv/setup

if test -z "$isNative"; then
    cflagsCompile="-B$out/bin -B$glibc/lib -isystem $glibc/include"
    ldflags="-L$glibc/lib -L$gcc/lib " \
        "-dynamic-linker $glibc/lib/ld-linux.so.2" \
        "-rpath $glibc/lib -rpath $gcc/lib"
else
    cflagsCompile="-B$out/bin"
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
        -e "s^@cflagsCompile@^$cflagsCompile^g" \
        -e "s^@cflagsLink@^$cflagsLink^g" \
        -e "s^@ldflags@^$ldflags^g" \
        -e "s^@gcc@^$src^g" \
        < $gccWrapper > $dst
    chmod +x $dst

}

mkGccWrapper $out/bin/gcc $gcc/bin/gcc
ln -s gcc $out/bin/cc

mkGccWrapper $out/bin/g++ $gcc/bin/g++
ln -s g++ $out/bin/c++

mkGccWrapper $out/bin/g77 $gcc/bin/g77
ln -s g77 $out/bin/f77


sed \
    -e "s^@ldflags@^$ldflags^g" \
    -e "s^@ld@^$gcc/bin/ld^g" \
    < $ldWrapper > $out/bin/ld
chmod +x $out/bin/ld


mkdir $out/nix-support
test -z "$isNative" && echo $gcc > $out/nix-support/orig-gcc
test -z "$isNative" && echo $glibc > $out/nix-support/orig-glibc

sed \
    -e "s^@isNative@^$isNative^g" \
    -e "s^@enforcePurity@^$enforcePurity^g" \
    -e "s^@gcc@^$gcc^g" \
    -e "s^@glibc@^$glibc^g" \
    < $setupHook > $out/nix-support/setup-hook
