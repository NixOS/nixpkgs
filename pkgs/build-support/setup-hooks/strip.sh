# This setup hook strips libraries and executables in the fixup phase.

fixupOutputHooks+=(_doStrip)

_doStrip() {
    if [ -z "$dontStrip" ]; then

        stripDirs "${stripDebugList:-*}" "${stripDebugFlags:--S}"

        if [ -n "${stripAllList:-}" ]; then
            stripDirs "${stripAllList:-}" "${stripAllFlags:--s}"
        fi
    fi
}

stripDirs() {
    local stripFlags="$2"

    # Ensure $prefix is a directory
    if [ -f "$prefix" ]; then
        header "Stripping (with flags $stripFlags) the file ${prefix}."
        echo -ne $prefix'\0' | stripAll "$stripFlags"
        stopNest
    fi
    [ -d "$prefix" ] || return 0

    # Ensure expansion occurs within $prefix/.
    pushd "$prefix" >/dev/null
        shopt -s dotglob
        local stripDirs=( $1 )
        local ignoreDirs=( $dontStripList )
        shopt -u dotglob
    popd >/dev/null
    local debugIncluded= debugExcluded= p=

    # `find` fails on missing paths. Remove them.
    local roots=()
    for p in "${stripDirs[@]}"; do
        if [ -e "$prefix/$p" ]; then
            roots+=( "$prefix/$p" )
            debugIncluded="$debugIncluded${debugIncluded:+,}$p"
        fi
    done
    [ "${#roots[@]}" -eq 0 ] && return 0

    # Add ignored paths to find command.
    local findArgs=( "${roots[@]}" )
    for p in "${ignoreDirs[@]}"; do
        if [ -e "$prefix/$p" ]; then
            findArgs+=( "-path" "$prefix/$p" "-prune" "-o" )
            debugExcluded="$debugExcluded $p"
        fi
    done

    header "Stripping (with flags $stripFlags) in $prefix${debugIncluded:+"/{$debugIncluded}"}${debugExcluded:+", skipping$debugExcluded"}."
    find "${findArgs[@]}" -type f -print0 | stripAll "$stripFlags"
    stopNest
}

stripAll() {
    local stripFlags="$1"

    local _ls f stripOutput
    while IFS= read -r -d $'\0' f; do
        # Skip very small files, they make strip choke.
        _ls=( $(ls -Ln "$f") )
        [ "${_ls[4]}" -lt 4 ] && continue;

        if stripOutput=$(strip $commonStripFlags $stripFlags "$f" 2>&1); then
            echo "Stripped $f"
        else
            # Ignore failures on files that cannot be stripped.
            [ "$stripOutput" = "strip:$f: File format not recognized" ] && continue
            [ "$stripOutput" = "strip:$f: File truncated" ] && continue

            [ -n "$stripOutput" ] && echo "$stripOutput"
            echo "Strip failed on file $f"
            false # fail !
        fi
    done
}
