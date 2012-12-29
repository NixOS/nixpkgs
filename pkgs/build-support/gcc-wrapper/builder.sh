source $stdenv/setup


mkdir -p $out/bin
mkdir -p $out/nix-support


if test -z "$nativeLibc"; then
    dynamicLinker="$libc/lib/$dynamicLinker"
    echo $dynamicLinker > $out/nix-support/dynamic-linker

    if test -e $libc/lib/32/ld-linux.so.2; then
        echo $libc/lib/32/ld-linux.so.2 > $out/nix-support/dynamic-linker-m32
    fi

    # The "-B$libc/lib/" flag is a quick hack to force gcc to link
    # against the crt1.o from our own glibc, rather than the one in
    # /usr/lib.  (This is only an issue when using an `impure'
    # compiler/linker, i.e., one that searches /usr/lib and so on.)
    #
    # Unfortunately, setting -B appears to override the default search
    # path. Thus, the gcc-specific "../includes-fixed" directory is
    # now longer searched and glibc's <limits.h> header fails to
    # compile, because it uses "#include_next <limits.h>" to find the
    # limits.h file in ../includes-fixed. To remedy the problem,
    # another -idirafter is necessary to add that directory again.
    echo "-B$libc/lib/ -idirafter $libc/include -idirafter $gcc/lib/gcc/*/*/include-fixed" > $out/nix-support/libc-cflags

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
    if [ -n "$langVhdl" ]; then
        gccLDFlags="$gccLDFlags -L$zlib/lib"
    fi
    echo "$gccLDFlags" > $out/nix-support/gcc-ldflags

    # GCC shows $gcc/lib in `gcc -print-search-dirs', but not
    # $gcc/lib64 (even though it does actually search there...)..
    # This confuses libtool.  So add it to the compiler tool search
    # path explicitly.
    if test -e "$gcc/lib64"; then
        gccCFlags="$gccCFlags -B$gcc/lib64"
    fi

    # Find the gcc libraries path (may work only without multilib)
    if [ -n "$langAda" ]; then
        basePath=`echo $gcc/lib/*/*/*`
        gccCFlags="$gccCFlags -B$basePath -I$basePath/adainclude"

        gnatCFlags="-aI$basePath/adainclude -aO$basePath/adalib"
        echo "$gnatCFlags" > $out/nix-support/gnat-cflags
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
        -e "s^@gnatProg@^$gnatProg^g" \
        -e "s^@gnatlinkProg@^$gnatlinkProg^g" \
        -e "s^@binutils@^$binutils^g" \
        -e "s^@coreutils@^$coreutils^g" \
        -e "s^@libc@^$libc^g" \
        -e "s^@ld@^$ldPath/ld^g" \
        < "$src" > "$dst" 
}


# Make wrapper scripts around gcc, g++, and gfortran.  Also make symlinks
# cc, c++, and f77.
mkGccWrapper() {
    local dst=$1
    local src=$2

    if ! test -f "$src"; then
        echo "$src does not exist (skipping)"
        return 1
    fi

    gccProg="$src"
    doSubstitute "$gccWrapper" "$dst"
    chmod +x "$dst"
}

mkGnatWrapper() {
    local dst=$1
    local src=$2

    if ! test -f "$src"; then
        echo "$src does not exist (skipping)"
        return 1
    fi

    gnatProg="$src"
    doSubstitute "$gnatWrapper" "$dst"
    chmod +x "$dst"
}

mkGnatLinkWrapper() {
    local dst=$1
    local src=$2

    if ! test -f "$src"; then
        echo "$src does not exist (skipping)"
        return 1
    fi

    gnatlinkProg="$src"
    doSubstitute "$gnatlinkWrapper" "$dst"
    chmod +x "$dst"
}

if mkGccWrapper $out/bin/gcc $gccPath/gcc
then
    ln -sv gcc $out/bin/cc
fi

if mkGccWrapper $out/bin/g++ $gccPath/g++
then
    ln -sv g++ $out/bin/c++
fi

if mkGccWrapper $out/bin/gfortran $gccPath/gfortran
then
    ln -sv gfortran $out/bin/g77
    ln -sv gfortran $out/bin/f77
fi

mkGccWrapper $out/bin/gcj $gccPath/gcj || true

mkGccWrapper $out/bin/gccgo $gccPath/gccgo || true

mkGccWrapper $out/bin/gnatgcc $gccPath/gnatgcc || true
mkGnatWrapper $out/bin/gnatmake $gccPath/gnatmake || true
mkGnatWrapper $out/bin/gnatbind $gccPath/gnatbind || true
mkGnatLinkWrapper $out/bin/gnatlink $gccPath/gnatlink || true

if [ -f $gccPath/ghdl ]; then
    ln -sf $gccPath/ghdl $out/bin/ghdl
fi


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
