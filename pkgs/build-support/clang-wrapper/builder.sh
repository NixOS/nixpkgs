source $stdenv/setup


mkdir -p $out/bin
mkdir -p $out/nix-support


if test -z "$nativeLibc"; then
    dynamicLinker="$libc/lib/$dynamicLinker"
    echo $dynamicLinker > $out/nix-support/dynamic-linker

    if test -e $libc/lib/32/ld-linux.so.2; then
        echo $libc/lib/32/ld-linux.so.2 > $out/nix-support/dynamic-linker-m32
    fi

    # The "-B$libc/lib/" flag is a quick hack to force clang to link
    # against the crt1.o from our own glibc, rather than the one in
    # /usr/lib.  (This is only an issue when using an `impure'
    # compiler/linker, i.e., one that searches /usr/lib and so on.)
    echo "-B$libc/lib/ -idirafter $libc/include" > $out/nix-support/libc-cflags

    echo "-L$libc/lib" > $out/nix-support/libc-ldflags

    # The dynamic linker is passed in `ldflagsBefore' to allow
    # explicit overrides of the dynamic linker by callers to clang/ld
    # (the *last* value counts, so ours should come first).
    echo "-dynamic-linker $dynamicLinker" > $out/nix-support/libc-ldflags-before
fi

if test -n "$nativeTools"; then
    clangPath="$nativePrefix/bin"
    ldPath="$nativePrefix/bin"
else
    basePath=`echo $gcc/lib/*/*/*`
    # Need libgcc until the llvm compiler-rt library is complete
    clangLDFlags="$clangLDFlags -L$basePath"
    if test -e "$gcc/lib64"; then
        clangLDFlags="$clangLDFlags -L$gcc/lib64"
    else
        clangLDFlags="$clangLDFlags -L$gcc/lib"
    fi

    clangLDFlags="$clangLDFlags -L$clang/lib"
    echo "$clangLDFlags" > $out/nix-support/clang-ldflags

    # Need files like crtbegin.o from gcc
    # It's unclear if these will ever be provided by an LLVM project
    clangCFlags="$clangCFlags -B$basePath"

    clangCFlags="$clangCFlags -isystem$clang/lib/clang/$clangVersion/include"
    echo "$clangCFlags" > $out/nix-support/clang-cflags
    
    clangPath="$clang/bin"
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
        -e "s^@clang@^$clang^g" \
        -e "s^@clangProg@^$clangProg^g" \
        -e "s^@binutils@^$binutils^g" \
        -e "s^@coreutils@^$coreutils^g" \
        -e "s^@libc@^$libc^g" \
        -e "s^@ld@^$ldPath/ld^g" \
        < "$src" > "$dst" 
}


# Make wrapper scripts around clang and clang++.  Also make symlinks
# cc and c++
mkClangWrapper() {
    local dst=$1
    local src=$2

    if ! test -f "$src"; then
        echo "$src does not exist (skipping)"
        return 1
    fi

    clangProg="$src"
    doSubstitute "$clangWrapper" "$dst"
    chmod +x "$dst"
}

if mkClangWrapper $out/bin/clang $clangPath/clang
then
    ln -sv clang $out/bin/cc
fi

if mkClangWrapper $out/bin/clang++ $clangPath/clang++
then
    ln -sv clang++ $out/bin/c++
fi


# Create a symlink to as (the assembler).  This is useful when a
# clang-wrapper is installed in a user environment, as it ensures that
# the right assembler is called.
ln -s $ldPath/as $out/bin/as


# Make a wrapper around the linker.
doSubstitute "$ldWrapper" "$out/bin/ld"
chmod +x "$out/bin/ld"


# Emit a setup hook.  Also store the path to the original Clang and
# libc.
test -n "$clang" && echo $clang > $out/nix-support/orig-clang
test -n "$libc" && echo $libc > $out/nix-support/orig-libc

doSubstitute "$addFlags" "$out/nix-support/add-flags.sh"

doSubstitute "$setupHook" "$out/nix-support/setup-hook"

cp -p $utils $out/nix-support/utils.sh


# Propagate the wrapped clang so that if you install the wrapper, you get
# llvm tools, the manpages, etc. as well (including for binutils
# and Glibc).
if test -z "$nativeTools"; then
    echo $clang $binutils $libc > $out/nix-support/propagated-user-env-packages
fi
