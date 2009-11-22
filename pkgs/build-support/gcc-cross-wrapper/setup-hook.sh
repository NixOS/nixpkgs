NIX_CROSS_CFLAGS_COMPILE=""
NIX_CROSS_LDFLAGS=""

crossAddCVars () {
    if test -d $1/include; then
        export NIX_CROSS_CFLAGS_COMPILE="$NIX_CROSS_CFLAGS_COMPILE -I$1/include"
    fi

    if test -d $1/lib; then
        export NIX_CROSS_LDFLAGS="$NIX_CROSS_LDFLAGS -L$1/lib -rpath-link $1/lib"
    fi
}

crossEnvHooks=(${crossEnvHooks[@]} crossAddCVars)

crossStripDirs() {
    local dirs="$1"
    local stripFlags="$2"
    local dirsNew=

    for d in ${dirs}; do
        if test -d "$prefix/$d"; then
            dirsNew="${dirsNew} $prefix/$d "
        fi
    done
    dirs=${dirsNew}

    if test -n "${dirs}"; then
        header "stripping (with flags $stripFlags) in $dirs"
        find $dirs -type f -print0 | xargs -0 ${xargsFlags:--r} $crossConfig-strip $stripFlags || true
        stopNest
    fi
}

crossStrip () {
    # TODO: strip _only_ ELF executables, and return || fail here...
    if test -z "$dontStrip"; then
        stripDebugList=${stripDebugList:-lib lib64 libexec bin sbin}
        if test -n "$stripDebugList"; then
            crossStripDirs "$stripDebugList" "${stripDebugFlags:--S}"
        fi
        
        stripAllList=${stripAllList:-}
        if test -n "$stripAllList"; then
            crossStripDirs "$stripAllList" "${stripAllFlags:--s}"
        fi
    fi
}

preDistPhases=(${preDistPhases[@]} crossStrip)


# Note: these come *after* $out in the PATH (see setup.sh).

if test -n "@gcc@"; then
    PATH=$PATH:@gcc@/bin
fi

if test -n "@binutils@"; then
    PATH=$PATH:@binutils@/bin
fi

if test -n "@libc@"; then
    PATH=$PATH:@libc@/bin
    crossAddCVars @libc@
fi

configureFlags="$configureFlags --build=$system --host=$crossConfig"
# Disabling the tests when cross compiling, as usually the tests are meant for
# native compilations.
doCheck=""

# Add the output as an rpath.
if test "$NIX_NO_SELF_RPATH" != "1"; then
    export NIX_CROSS_LDFLAGS="-rpath $out/lib -rpath-link $out/lib $NIX_CROSS_LDFLAGS"
    if test -n "$NIX_LIB64_IN_SELF_RPATH"; then
        export NIX_CROSS_LDFLAGS="-rpath $out/lib64 -rpath-link $out/lib $NIX_CROSS_LDFLAGS"
    fi
fi
