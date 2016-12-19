# This setup hook causes the fixup phase to rewrite all script
# interpreter file names (`#!  /path') to paths found in $PATH.  E.g.,
# /bin/sh will be rewritten to /nix/store/<hash>-some-bash/bin/sh.
# /usr/bin/env gets special treatment so that ".../bin/env python" is
# rewritten to /nix/store/<hash>/bin/python.  Interpreters that are
# already in the store are left untouched.

fixupOutputHooks+=('if [ -z "$dontPatchShebangs" -a -e "$prefix" ]; then patchShebangs "$prefix"; fi')

patchShebangs() {
    local dir="$1"
    header "patching script interpreter paths in $dir"
    local f
    local oldPath
    local newPath
    local arg0
    local args
    local oldInterpreterLine
    local newInterpreterLine

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
            newPath="$(command -v "$arg0" || true)"
        else
            if [ "$oldPath" = "" ]; then
                # If no interpreter is specified linux will use /bin/sh. Set
                # oldpath="/bin/sh" so that we get /nix/store/.../sh.
                oldPath="/bin/sh"
            fi
            newPath="$(command -v "$(basename "$oldPath")" || true)"
            args="$arg0 $args"
        fi

        # Strip trailing whitespace introduced when no arguments are present
        newInterpreterLine="$(echo "$newPath $args" | sed 's/[[:space:]]*$//')"

        if [ -n "$oldPath" -a "${oldPath:0:${#NIX_STORE}}" != "$NIX_STORE" ]; then
            if [ -n "$newPath" -a "$newPath" != "$oldPath" ]; then
                echo "$f: interpreter directive changed from \"$oldInterpreterLine\" to \"$newInterpreterLine\""
                # escape the escape chars so that sed doesn't interpret them
                escapedInterpreterLine=$(echo "$newInterpreterLine" | sed 's|\\|\\\\|g')
                sed -i -e "1 s|.*|#\!$escapedInterpreterLine|" "$f"
            fi
        fi
    done

    stopNest
}
