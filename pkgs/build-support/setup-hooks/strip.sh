# shellcheck shell=bash
# This setup hook strips libraries and executables in the fixup phase.

fixupOutputHooks+=(_doStrip)

_doStrip() {
    # We don't bother to strip build platform code because it shouldn't make it
    # to $out anyways---if it does, that's a bigger problem that a lack of
    # stripping will help catch.
    local -ra flags=(dontStripHost dontStripTarget)
    local -ra stripCmds=(STRIP TARGET_STRIP)

    # Optimization
    if [[ "${STRIP-}" == "${TARGET_STRIP-}" ]]; then
        dontStripTarget+=1
    fi

    local i
    for i in ${!stripCmds[@]}; do
        local -n flag="${flags[$i]}"
        local -n stripCmd="${stripCmds[$i]}"

        # `dontStrip` disables them all
        if [[ "${dontStrip-}" || "${flag-}" ]] || ! type -f "${stripCmd-}" 2>/dev/null
        then continue; fi

        stripDebugList=${stripDebugList:-lib lib32 lib64 libexec bin sbin}
        if [ -n "$stripDebugList" ]; then
            stripDirs "$stripCmd" "$stripDebugList" "${stripDebugFlags:--S}"
        fi

        stripAllList=${stripAllList:-}
        if [ -n "$stripAllList" ]; then
            stripDirs "$stripCmd" "$stripAllList" "${stripAllFlags:--s}"
        fi
    done
}

stripDirs() {
    local cmd="$1"
    local dirs="$2"
    local stripFlags="$3"
    local dirsNew=

    local d
    for d in ${dirs}; do
        if [ -d "$prefix/$d" ]; then
            dirsNew="${dirsNew} $prefix/$d "
        fi
    done
    dirs=${dirsNew}

    if [ -n "${dirs}" ]; then
        header "stripping (with command $cmd and flags $stripFlags) in$dirs"
        find $dirs -type f -exec $cmd $stripFlags '{}' \; 2>/dev/null
        stopNest
    fi
}
