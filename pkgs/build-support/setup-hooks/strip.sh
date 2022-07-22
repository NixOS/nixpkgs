# This setup hook strips libraries and executables in the fixup phase.

fixupOutputHooks+=(_doStrip)

_doStrip() {
    # We don't bother to strip build platform code because it shouldn't make it
    # to $out anyways---if it does, that's a bigger problem that a lack of
    # stripping will help catch.
    local -ra flags=(dontStripHost dontStripTarget)
    local -ra debugDirs=(stripDebugList stripDebugListTarget)
    local -ra allDirs=(stripAllList stripAllListTarget)
    local -ra stripCmds=(STRIP STRIP_FOR_TARGET)

    # Strip only host paths by default. Leave targets as is.
    stripDebugList=${stripDebugList:-lib lib32 lib64 libexec bin sbin}
    stripDebugListTarget=${stripDebugListTarget:-}
    stripAllList=${stripAllList:-}
    stripAllListTarget=${stripAllListTarget:-}

    local i
    for i in ${!stripCmds[@]}; do
        local -n flag="${flags[$i]}"
        local -n debugDirList="${debugDirs[$i]}"
        local -n allDirList="${allDirs[$i]}"
        local -n stripCmd="${stripCmds[$i]}"

        # `dontStrip` disables them all
        if [[ "${dontStrip-}" || "${flag-}" ]] || ! type -f "${stripCmd-}" 2>/dev/null
        then continue; fi

        stripDirs "$stripCmd" "$debugDirList" "${stripDebugFlags:--S}"
        stripDirs "$stripCmd" "$allDirList" "${stripAllFlags:--s}"
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
        echo "stripping (with command $cmd and flags $stripFlags) in$dirs"
        find $dirs -type f -exec $cmd $stripFlags '{}' \; 2>/dev/null
    fi
}
