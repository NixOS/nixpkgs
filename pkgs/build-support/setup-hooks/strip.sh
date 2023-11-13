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
    local -ra ranlibCmds=(RANLIB RANLIB_FOR_TARGET)

    # TODO(structured-attrs): This doesn't work correctly if one of
    #   the items in strip*List or strip*Flags contains a space,
    #   even with structured attrs enabled.  This is OK for now
    #   because very few packages set any of these, and it doesn't
    #   affect any of them.
    #
    #   After __structuredAttrs = true is universal, come back and
    #   push arrays all the way through this logic.

    # Strip only host paths by default. Leave targets as is.
    stripDebugList=${stripDebugList[*]:-lib lib32 lib64 libexec bin sbin}
    stripDebugListTarget=${stripDebugListTarget[*]:-}
    stripAllList=${stripAllList[*]:-}
    stripAllListTarget=${stripAllListTarget[*]:-}

    local i
    for i in ${!stripCmds[@]}; do
        local -n flag="${flags[$i]}"
        local -n debugDirList="${debugDirs[$i]}"
        local -n allDirList="${allDirs[$i]}"
        local -n stripCmd="${stripCmds[$i]}"
        local -n ranlibCmd="${ranlibCmds[$i]}"

        # `dontStrip` disables them all
        if [[ "${dontStrip-}" || "${flag-}" ]] || ! type -f "${stripCmd-}" 2>/dev/null 1>&2
        then continue; fi

        stripDirs "$stripCmd" "$ranlibCmd" "$debugDirList" "${stripDebugFlags[*]:--S -p}"
        stripDirs "$stripCmd" "$ranlibCmd" "$allDirList" "${stripAllFlags[*]:--s -p}"
    done
}

stripDirs() {
    local cmd="$1"
    local ranlibCmd="$2"
    local paths="$3"
    local stripFlags="$4"
    local excludeFlags=()
    local pathsNew=

    [ -z "$cmd" ] && echo "stripDirs: Strip command is empty" 1>&2 && exit 1
    [ -z "$ranlibCmd" ] && echo "stripDirs: Ranlib command is empty" 1>&2 && exit 1

    local pattern
    if [ -n "${stripExclude:-}" ]; then
        for pattern in "${stripExclude[@]}"; do
            excludeFlags+=(-a '!' '(' -name "$pattern" -o -wholename "$prefix/$pattern" ')' )
        done
    fi

    local p
    for p in ${paths}; do
        if [ -e "$prefix/$p" ]; then
            pathsNew="${pathsNew} $prefix/$p"
        fi
    done
    paths=${pathsNew}

    if [ -n "${paths}" ]; then
        echo "stripping (with command $cmd and flags $stripFlags) in $paths"
        local striperr
        striperr="$(mktemp --tmpdir="$TMPDIR" 'striperr.XXXXXX')"
        # Do not strip lib/debug. This is a directory used by setup-hooks/separate-debug-info.sh.
        find $paths -type f "${excludeFlags[@]}" -a '!' -path "$prefix/lib/debug/*" -print0 |
            # Make sure we process files under symlinks only once. Otherwise
            # 'strip` can corrupt files when writes to them in parallel:
            #   https://github.com/NixOS/nixpkgs/issues/246147#issuecomment-1657072039
            xargs -r -0 -n1 -- realpath -z | sort -u -z |

            xargs -r -0 -n1 -P "$NIX_BUILD_CORES" -- $cmd $stripFlags 2>"$striperr" || exit_code=$?
        # xargs exits with status code 123 if some but not all of the
        # processes fail. We don't care if some of the files couldn't
        # be stripped, so ignore specifically this code.
        [[ "$exit_code" = 123 || -z "$exit_code" ]] || (cat "$striperr" 1>&2 && exit 1)

        rm "$striperr"
        # 'strip' does not normally preserve archive index in .a files.
        # This usually causes linking failures against static libs like:
        #   ld: ...-i686-w64-mingw32-stage-final-gcc-13.0.0-lib/i686-w64-mingw32/lib/libstdc++.dll.a:
        #     error adding symbols: archive has no index; run ranlib to add one
        # Restore the index by running 'ranlib'.
        find $paths -name '*.a' -type f -exec $ranlibCmd '{}' \; 2>/dev/null
    fi
}
