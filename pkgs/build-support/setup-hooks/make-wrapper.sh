# Assert that FILE exists and is executable
#
# assertExecutable FILE
assertExecutable() {
    local file="$1"
    [[ -f "$file" && -x "$file" ]] || \
        die "Cannot wrap '$file' because it is not an executable file"
}

# construct an executable file that wraps the actual executable
# makeWrapper EXECUTABLE ARGS

# ARGS:
# --argv0 NAME      : set name of executed process to NAME
#                     (otherwise it’s called …-wrapped)
# --set   VAR VAL   : add VAR with value VAL to the executable’s environment
# --unset VAR       : remove VAR from the environment
# --run   COMMAND   : run command before the executable
#                     The command can push extra flags to a magic list variable
#                     extraFlagsArray, which are then added to the invocation
#                     of the executable
# --add-flags FLAGS : add FLAGS to invocation of executable

# --prefix          ENV SEP VAL   : suffix/prefix ENV with VAL, separated by SEP
# --suffix
# --suffix-each     ENV SEP VALS  : like --suffix, but VALS is a list
# --prefix-contents ENV SEP FILES : like --suffix-each, but contents of FILES
#                                   are read first and used as VALS
# --suffix-contents
makeWrapper() {
    local original="$1"
    local wrapper="$2"
    shift 2
    local -a flagsBefore=()

    assertExecutable "$original"

    mkdir -p "$(dirname "$wrapper")"

    echo "#! $SHELL -eu" > "$wrapper"
    echo "declare -a extraFlagsArray=()" >> "$wrapper"

    while (( $# )); do
    case "$1" in
        --set)
            local varName="$2"
            local value="$3"
            shift 3
            echo "export $varName=${value@Q}" >> "$wrapper"
            ;;
        --set-default)
            local varName="$2"
            local value="$3"
            shift 3
            echo "export $varName=\${$varName-${value@Q}}" >> "$wrapper"
            ;;
        --unset)
            local varName="$2"
            shift 2
            echo "unset $varName" >> "$wrapper"
            ;;
        --run)
            local command="$2"
            shift 2
            echo "set +u" >> "$wrapper"
            echo "$command" >> "$wrapper"
            echo "set -u" >> "$wrapper"
            ;;
        --suffix | --prefix)
            local flag="$1"
            local varName="$2"
            local separator="$3"
            local value="$4"
            shift 4
            if test -n "$value"; then
                if test "$flag" = "--suffix"; then
                    echo "export $varName+=\${$varName:+${separator@Q}}${value@Q}" >> "$wrapper"
                else
                    echo "export $varName=${value@Q}\${$varName:+${separator@Q}\$$varName}" >> "$wrapper"
                fi
            fi
            ;;
        --suffix-each)
            local varName="$2"
            local separator="$3"
            local values="$4"
            shift 4
            for value in $values; do
                echo "export $varName+=\${$varName:+${separator@Q}}${value@Q}" >> "$wrapper"
            done
            ;;
        --suffix-contents | --prefix-contents)
            local flag="$1"
            local varName="$2"
            local separator="$3"
            local fileNames="$4"
            shift 4
            for fileName in $fileNames; do
                contents="$(< "$fileName")"
                if test "$flag" = "--suffix-contents"; then
                    echo "export $varName+=\${$varName:+${separator@Q}}${contents@Q}" >> "$wrapper"
                else
                    echo "export $varName=${contents@Q}\${$varName:+${separator@Q}\$$varName}" >> "$wrapper"
                fi
            done
            ;;
        --add-flags)
            local flags="$2"
            shift 2
            flagsBefore+=($flags)
            ;;
        --argv0)
            local argv0="$2"
            shift 2
            ;;
        *)
            die "makeWrapper doesn't understand the arg ${1@Q}"
            ;;
    esac
    done

    echo "set +u" >> "$wrapper"
    # Note: extraFlagsArray is an array containing additional flags
    # that may be set by --run actions.
    # Silence warning about unexpanded extraFlagsArray:
    # shellcheck disable=SC2016
    echo exec ${argv0:+-a "${argv0@Q}"} "${original@Q}" \
        "${flagsBefore[@]}" '"${extraFlagsArray[@]}"' '"$@"' >> "$wrapper"

    chmod +x "$wrapper"
}

addSuffix() {
    suffix="$1"
    shift
    for name in "$@"; do
        echo "$name$suffix"
    done
}

filterExisting() {
    for fn in "$@"; do
        if test -e "$fn"; then
            echo "$fn"
        fi
    done
}

# Syntax: wrapProgram <PROGRAM> <MAKE-WRAPPER FLAGS...>
wrapProgram() {
    local prog="$1"
    local hidden

    assertExecutable "$prog"

    hidden="$(dirname "$prog")/.$(basename "$prog")"-wrapped
    while [ -e "$hidden" ]; do
      hidden="${hidden}_"
    done
    mv "$prog" "$hidden"
    # Silence warning about unexpanded $0:
    # shellcheck disable=SC2016
    makeWrapper "$hidden" "$prog" --argv0 '$0' "${@:2}"
}
