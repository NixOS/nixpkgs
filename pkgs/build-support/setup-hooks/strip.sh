# This setup hook strips libraries and executables in the fixup phase.

fixupOutputHooks+=(_doStrip)

_doStrip() {
    if [ -z "$dontStrip" ]; then
        stripDebugList=${stripDebugList:-.}
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
        header "Stripping (with flags $stripFlags) in$dirs"
        while IFS= read -r -d $'\0' f; do
            if out=$(strip $commonStripFlags $stripFlags "$f" 2>&1); then
                echo "Stripped $f"
            else
                # Ignore failures on files that cannot be stripped.
                if [ "$out" = "strip:$f: File format not recognized" ]; then
                    continue
                fi

                echo "Strip failed on file $f: $out"
                false # fail !
            fi
        done < <(find $dirs -type f -print0)
        stopNest
    fi
}
