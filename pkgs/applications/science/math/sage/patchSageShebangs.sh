# This is a slightly modified version of nix's default patchShebangs

dir="$1"

echo "patching sage internal script interpreter paths in $( readlink -f "$dir")"

find "$dir" -type f -perm -0100 | while read f; do
    if [ "$(head -1 "$f" | head -c+2)" != '#!' ]; then
        # missing shebang => not a script
        continue
    fi

    oldInterpreterLine=$(head -1 "$f" | tail -c+3)
    read -r oldPath arg0 args <<< "$oldInterpreterLine"

    if $(echo "$oldPath" | grep -q "/bin/env$"); then
        # Check for unsupported 'env' functionality:
        # - options: something starting with a '-'
        # - environment variables: foo=bar
        if $(echo "$arg0" | grep -q -- "^-.*\|.*=.*"); then
            echo "unsupported interpreter directive \"$oldInterpreterLine\" (set dontPatchShebangs=1 and handle shebang patching yourself)"
            exit 1
        fi
        executable="$arg0"
    else
        if [ "$oldPath" = "" ]; then
            # If no interpreter is specified linux will use /bin/sh. Set
            # oldpath="/bin/sh" so that we get /nix/store/.../sh.
            oldPath="/bin/sh"
        fi
        executable="$(basename "$oldPath")"
        args="$arg0 $args"
    fi

    newPath="$(echo "$out/bin/$executable $args" | sed 's/[[:space:]]*$//')"
    if [[ ! -x "$newPath" ]] ; then
        newPath="$(command -v "$executable" || true)"
    fi

    # Strip trailing whitespace introduced when no arguments are present
    newInterpreterLine="$(echo "$newPath $args" | sed 's/[[:space:]]*$//')"

    if [ -n "$oldPath" -a "${oldPath:0:${#NIX_STORE}}" != "$NIX_STORE" ]; then
        if [ -n "$newPath" -a "$newPath" != "$oldPath" ]; then
            echo "$f: sage interpreter directive changed from \"$oldInterpreterLine\" to \"$newInterpreterLine\""
            # escape the escape chars so that sed doesn't interpret them
            escapedInterpreterLine=$(echo "$newInterpreterLine" | sed 's|\\|\\\\|g')
            sed -i -e "1 s|.*|#\!$escapedInterpreterLine|" "$f"
        fi
    fi
done
