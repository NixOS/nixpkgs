# This setup hook causes the fixup phase to rewrite all script
# interpreter file names (`#!  /path') to paths found in $PATH.  E.g.,
# /bin/sh will be rewritten to /nix/store/<hash>-some-bash/bin/sh.
# /usr/bin/env gets special treatment so that ".../bin/env python" is
# rewritten to /nix/store/<hash>/bin/python.  Interpreters that are
# already in the store are left untouched.
# A script file must be marked as executable, otherwise it will not be
# considered.

fixupOutputHooks+=(patchShebangsAuto)

# Run patch shebangs on a directory or file.
# Can take multiple paths as arguments.
# patchShebangs [--build | --host | --update] [--] PATH...

# Flags:
# --build : Lookup commands available at build-time
# --host  : Lookup commands available at runtime
# --update : Update shebang paths that are in Nix store

# Example use cases,
# $ patchShebangs --host /nix/store/...-hello-1.0/bin
# $ patchShebangs --build configure

patchShebangs() {
    local pathName
    local update

    while [[ $# -gt 0 ]]; do
        case "$1" in
        --host)
            pathName=HOST_PATH
            shift
            ;;
        --build)
            pathName=PATH
            shift
            ;;
        --update)
            update=true
            shift
            ;;
        --)
            shift
            break
            ;;
        -*|--*)
            echo "Unknown option $1 supplied to patchShebangs" >&2
            return 1
            ;;
        *)
            break
            ;;
        esac
    done

    echo "patching script interpreter paths in $@"
    local f
    local oldPath
    local newPath
    local arg0
    local args
    local oldInterpreterLine
    local newInterpreterLine

    if [[ $# -eq 0 ]]; then
        echo "No arguments supplied to patchShebangs" >&2
        return 0
    fi

    local f
    while IFS= read -r -d $'\0' f; do
        isScript "$f" || continue

        read -r oldInterpreterLine < "$f"
        read -r oldPath arg0 args <<< "${oldInterpreterLine:2}"

        if [[ -z "$pathName" ]]; then
            if [[ -n $strictDeps && $f == "$NIX_STORE"* ]]; then
                pathName=HOST_PATH
            else
                pathName=PATH
            fi
        fi

        if [[ "$oldPath" == *"/bin/env" ]]; then
            if [[ $arg0 == "-S" ]]; then
                arg0=${args%% *}
                args=${args#* }
                newPath="$(PATH="${!pathName}" command -v "env" || true)"
                args="-S $(PATH="${!pathName}" command -v "$arg0" || true) $args"

            # Check for unsupported 'env' functionality:
            # - options: something starting with a '-' besides '-S'
            # - environment variables: foo=bar
            elif [[ $arg0 == "-"* || $arg0 == *"="* ]]; then
                echo "$f: unsupported interpreter directive \"$oldInterpreterLine\" (set dontPatchShebangs=1 and handle shebang patching yourself)" >&2
                exit 1
            else
                newPath="$(PATH="${!pathName}" command -v "$arg0" || true)"
            fi
        else
            if [[ -z $oldPath ]]; then
                # If no interpreter is specified linux will use /bin/sh. Set
                # oldpath="/bin/sh" so that we get /nix/store/.../sh.
                oldPath="/bin/sh"
            fi

            newPath="$(PATH="${!pathName}" command -v "$(basename "$oldPath")" || true)"

            args="$arg0 $args"
        fi

        # Strip trailing whitespace introduced when no arguments are present
        newInterpreterLine="$newPath $args"
        newInterpreterLine=${newInterpreterLine%${newInterpreterLine##*[![:space:]]}}

        if [[ -n "$oldPath" && ( "$update" == true || "${oldPath:0:${#NIX_STORE}}" != "$NIX_STORE" ) ]]; then
            if [[ -n "$newPath" && "$newPath" != "$oldPath" ]]; then
                echo "$f: interpreter directive changed from \"$oldInterpreterLine\" to \"$newInterpreterLine\""
                # escape the escape chars so that sed doesn't interpret them
                escapedInterpreterLine=${newInterpreterLine//\\/\\\\}

                # Preserve times, see: https://github.com/NixOS/nixpkgs/pull/33281
                timestamp=$(stat --printf "%y" "$f")
                sed -i -e "1 s|.*|#\!$escapedInterpreterLine|" "$f"
                touch --date "$timestamp" "$f"
            fi
        fi
    done < <(find "$@" -type f -perm -0100 -print0)
}

patchShebangsAuto () {
    if [[ -z "${dontPatchShebangs-}" && -e "$prefix" ]]; then

        # Dev output will end up being run on the build platform. An
        # example case of this is sdl2-config. Otherwise, we can just
        # use the runtime path (--host).
        if [[ "$output" != out && "$output" = "$outputDev" ]]; then
            patchShebangs --build "$prefix"
        else
            patchShebangs --host "$prefix"
        fi
    fi
}
