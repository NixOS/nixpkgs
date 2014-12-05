# This setup hook strips libraries and executables in the fixup phase.

fixupOutputHooks+=(_doStrip)

_doStrip() {
    if [ -z "$dontStrip" ]; then
        stripDebugList=${stripDebugList:-lib lib32 lib64 libexec bin sbin}
        if [ -n "$stripDebugList" ]; then
            stripDirs "$stripDebugList" "${stripDebugFlags:--S}"
        fi

        stripAllList=${stripAllList:-}
        if [ -n "$stripAllList" ]; then
            stripDirs "$stripAllList" "${stripAllFlags:--s}"
        fi
    fi
}

stripDirs() {
    local dirs="$1"
    local stripFlags="$2"
    local dirsNew=

    for d in ${dirs}; do
        if [ -d "$prefix/$d" ]; then
            dirsNew="${dirsNew} $prefix/$d "
        fi
    done
    dirs=${dirsNew}

    if [ -n "${dirs}" ]; then
        header "stripping (with flags $stripFlags) in$dirs"
        find $dirs -type f -print0 | xargs -0 ${xargsFlags:--r} strip $commonStripFlags $stripFlags || true
        stopNest
    fi
}
