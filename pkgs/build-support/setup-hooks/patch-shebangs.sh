# This setup hook causes the fixup phase to rewrite all script
# interpreter file names (`#!  /path') to paths found in $PATH.  E.g.,
# /bin/sh will be rewritten to /nix/store/<hash>-some-bash/bin/sh.
# /usr/bin/env gets special treatment so that ".../bin/env python" is
# rewritten to /nix/store/<hash>/bin/python.  Interpreters that are
# already in the store are left untouched.

fixupOutputHooks+=(patchShebangsAuto)

# Run patch shebangs on a directory.
# patchShebangs [--build | --host] directory

# Flags:
# --build : Lookup commands available at build-time
# --host  : Lookup commands available at runtime

# Example use cases,
# $ patchShebangs --host /nix/store/...-hello-1.0/bin
# $ patchShebangs --build configure

patchShebangs() {
    local pathName

    if [ "$1" = "--host" ]; then
        pathName=HOST_PATH
        shift
    elif [ "$1" = "--build" ]; then
        pathName=PATH
        shift
    fi

    local dir="$1"

    header "patching script interpreter paths in $dir"
    local f
    local oldPath
    local newPath
    local arg0
    local args
    local oldInterpreterLine
    local newInterpreterLine

    [ -e "$dir" ] || return 0

    local f
    while IFS= read -r -d $'\0' f; do
        isScript "$f" || continue

        oldInterpreterLine=$(head -1 "$f" | tail -c+3)
        read -r oldPath arg0 args <<< "$oldInterpreterLine"

        if [ -z "$pathName" ]; then
            if [ -n "$strictDeps" ] && [[ "$f" = "$NIX_STORE"* ]]; then
                pathName=HOST_PATH
            else
                pathName=PATH
            fi
        fi

        if $(echo "$oldPath" | grep -q "/bin/env$"); then
            # Check for unsupported 'env' functionality:
            # - options: something starting with a '-'
            # - environment variables: foo=bar
            if $(echo "$arg0" | grep -q -- "^-.*\|.*=.*"); then
                echo "$f: unsupported interpreter directive \"$oldInterpreterLine\" (set dontPatchShebangs=1 and handle shebang patching yourself)"
                exit 1
            fi

            newPath="$(PATH="${!pathName}" command -v "$arg0" || true)"
        else
            if [ "$oldPath" = "" ]; then
                # If no interpreter is specified linux will use /bin/sh. Set
                # oldpath="/bin/sh" so that we get /nix/store/.../sh.
                oldPath="/bin/sh"
            fi

            newPath="$(PATH="${!pathName}" command -v "$(basename "$oldPath")" || true)"

            args="$arg0 $args"
        fi

        # Strip trailing whitespace introduced when no arguments are present
        newInterpreterLine="$(echo "$newPath $args" | sed 's/[[:space:]]*$//')"

        if [ -n "$oldPath" -a "${oldPath:0:${#NIX_STORE}}" != "$NIX_STORE" ]; then
            if [ -n "$newPath" -a "$newPath" != "$oldPath" ]; then
                echo "$f: interpreter directive changed from \"$oldInterpreterLine\" to \"$newInterpreterLine\""
                # escape the escape chars so that sed doesn't interpret them
                escapedInterpreterLine=$(echo "$newInterpreterLine" | sed 's|\\|\\\\|g')
                # Preserve times, see: https://github.com/NixOS/nixpkgs/pull/33281
                timestamp=$(mktemp)
                touch -r "$f" "$timestamp"
                sed -i -e "1 s|.*|#\!$escapedInterpreterLine|" "$f"
                touch -r "$timestamp" "$f"
                rm "$timestamp"
            fi
        fi
    done < <(find "$dir" -type f -perm -0100 -print0)

    stopNest
}

patchShebangsAuto () {
    if [ -z "$dontPatchShebangs" -a -e "$prefix" ]; then

        # Dev output will end up being run on the build platform. An
        # example case of this is sdl2-config. Otherwise, we can just
        # use the runtime path (--host).
        if [ "$output" != out ] && [ "$output" = "$outputDev" ]; then
            patchShebangs --build "$prefix"
        else
            patchShebangs --host "$prefix"
        fi
    fi
}
