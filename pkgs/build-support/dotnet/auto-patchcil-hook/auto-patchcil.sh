#!@shell@
# shellcheck shell=bash

declare -a autoPatchcilLibs
declare -a extraAutoPatchcilLibs

gatherLibraries() {
    if [ -d "$1/lib" ]; then
        autoPatchcilLibs+=("$1/lib")
    fi
}

addEnvHooks "${targetOffset:?}" gatherLibraries

# Can be used to manually add additional directories with shared object files
# to be included for the next autoPatchcil invocation.
addAutoPatchcilSearchPath() {
    local -a findOpts=()

    while [ $# -gt 0 ]; do
        case "$1" in
        --)
            shift
            break
            ;;
        --no-recurse)
            shift
            findOpts+=("-maxdepth" 1)
            ;;
        --*)
            echo "addAutoPatchcilSearchPath: ERROR: Invalid command line" \
                "argument: $1" >&2
            return 1
            ;;
        *) break ;;
        esac
    done

    local dir=
    while IFS= read -r -d '' dir; do
        extraAutoPatchcilLibs+=("$dir")
    done < <(
        find "$@" "${findOpts[@]}" \! -type d \
            \( -name '*.so' -o -name '*.so.*' \) -print0 |
            sed -z 's#/[^/]*$##' |
            uniq -z
    )
}

autoPatchcil() {
    local rid=
    local norecurse=
    while [ $# -gt 0 ]; do
        case "$1" in
        --)
            shift
            break
            ;;
        --rid)
            rid="$2"
            shift 2
            ;;
        --no-recurse)
            shift
            norecurse=1
            ;;
        --*)
            echo "autoPatchcil: ERROR: Invalid command line" \
                "argument: $1" >&2
            return 1
            ;;
        *) break ;;
        esac
    done

    if [ -z "$rid" ]; then
        echo "autoPatchcil: ERROR: No RID (Runtime ID) provided." >&2
        return 1
    fi

    local ignoreMissingDepsArray=("--ignore-missing")
    concatTo ignoreMissingDepsArray autoPatchcilIgnoreMissingDeps

    if [ ${#ignoreMissingDepsArray[@]} -lt 2 ]; then
        ignoreMissingDepsArray=()
    fi

    local autoPatchcilFlags=(
        ${norecurse:+--no-recurse}
        --rid "$rid"
        "${ignoreMissingDepsArray[@]}"
        --paths "$@"
        --libs "${autoPatchcilLibs[@]}"
    )

    # shellcheck disable=SC2016
    echoCmd 'patchcil auto flags' "${autoPatchcilFlags[@]}"
    @patchcil@ auto "${autoPatchcilFlags[@]}"
}

autoPatchcilFixupOutput() {
    if [[ -z "${dontAutoPatchcil-}" ]]; then
        if [ -n "${dotnetRuntimeIds+x}" ]; then
            if [[ -n $__structuredAttrs ]]; then
                local dotnetRuntimeIdsArray=("${dotnetRuntimeIds[@]}")
            else
                # shellcheck disable=SC2206 # Intentionally expanding it to preserve old behavior
                local dotnetRuntimeIdsArray=($dotnetRuntimeIds)
            fi
        else
            local dotnetRuntimeIdsArray=("")
        fi

        autoPatchcil --rid "${autoPatchcilRuntimeId:-${dotnetRuntimeIdsArray[0]}}" -- "${prefix:?}"
    fi
}

fixupOutputHooks+=(autoPatchcilFixupOutput)
