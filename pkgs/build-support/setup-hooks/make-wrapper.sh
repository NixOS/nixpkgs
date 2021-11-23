# shellcheck shell=bash
# Assert that FILE exists and is executable
#
# assertExecutable FILE
assertExecutable() {
    local file="$1"
    [[ -f "$file" && -x "$file" ]] || \
        die "Cannot wrap '$file' because it is not an executable file"
}

# construct an executable file that wraps the actual executable
# makeWrapper EXECUTABLE OUT_PATH ARGS

# ARGS:
# --argv0       NAME    : set name of executed process to NAME
#                         (otherwise it’s called …-wrapped)
# --set         VAR VAL : add VAR with value VAL to the executable’s
#                         environment
# --set-default VAR VAL : like --set, but only adds VAR if not already set in
#                         the environment
# --unset       VAR     : remove VAR from the environment
# --run         COMMAND : run command before the executable
# --add-flags   FLAGS   : add FLAGS to invocation of executable

# --prefix          ENV SEP VAL   : suffix/prefix ENV with VAL, separated by SEP
# --suffix
# --suffix-each     ENV SEP VALS  : like --suffix, but VALS is a list
# --prefix-contents ENV SEP FILES : like --suffix-each, but contents of FILES
#                                   are read first and used as VALS
# --suffix-contents
makeWrapper() {
    local original="$1"
    local wrapper="$2"
    local params varName value command separator n fileNames
    local argv0 flagsBefore flags

    assertExecutable "$original"

    mkdir -p "$(dirname "$wrapper")"

    echo "#! @shell@ -e" > "$wrapper"

    params=("$@")
    for ((n = 2; n < ${#params[*]}; n += 1)); do
        p="${params[$n]}"

        if [[ "$p" == "--set" ]]; then
            varName="${params[$((n + 1))]}"
            value="${params[$((n + 2))]}"
            n=$((n + 2))
            echo "export $varName=${value@Q}" >> "$wrapper"
        elif [[ "$p" == "--set-default" ]]; then
            varName="${params[$((n + 1))]}"
            value="${params[$((n + 2))]}"
            n=$((n + 2))
            echo "export $varName=\${$varName-${value@Q}}" >> "$wrapper"
        elif [[ "$p" == "--unset" ]]; then
            varName="${params[$((n + 1))]}"
            n=$((n + 1))
            echo "unset $varName" >> "$wrapper"
        elif [[ "$p" == "--run" ]]; then
            command="${params[$((n + 1))]}"
            n=$((n + 1))
            echo "$command" >> "$wrapper"
        elif [[ ("$p" == "--suffix") || ("$p" == "--prefix") ]]; then
            varName="${params[$((n + 1))]}"
            separator="${params[$((n + 2))]}"
            value="${params[$((n + 3))]}"
            n=$((n + 3))
            if test -n "$value"; then
                if test "$p" = "--suffix"; then
                    echo "export $varName=\$$varName\${$varName:+${separator@Q}}${value@Q}" >> "$wrapper"
                else
                    echo "export $varName=${value@Q}\${$varName:+${separator@Q}}\$$varName" >> "$wrapper"
                fi
            fi
        elif [[ "$p" == "--suffix-each" ]]; then
            varName="${params[$((n + 1))]}"
            separator="${params[$((n + 2))]}"
            values="${params[$((n + 3))]}"
            n=$((n + 3))
            for value in $values; do
                echo "export $varName=\$$varName\${$varName:+$separator}${value@Q}" >> "$wrapper"
            done
        elif [[ ("$p" == "--suffix-contents") || ("$p" == "--prefix-contents") ]]; then
            varName="${params[$((n + 1))]}"
            separator="${params[$((n + 2))]}"
            fileNames="${params[$((n + 3))]}"
            n=$((n + 3))
            for fileName in $fileNames; do
                contents="$(cat "$fileName")"
                if test "$p" = "--suffix-contents"; then
                    echo "export $varName=\$$varName\${$varName:+$separator}${contents@Q}" >> "$wrapper"
                else
                    echo "export $varName=${contents@Q}\${$varName:+$separator}\$$varName" >> "$wrapper"
                fi
            done
        elif [[ "$p" == "--add-flags" ]]; then
            flags="${params[$((n + 1))]}"
            n=$((n + 1))
            flagsBefore="$flagsBefore $flags"
        elif [[ "$p" == "--argv0" ]]; then
            argv0="${params[$((n + 1))]}"
            n=$((n + 1))
        else
            die "makeWrapper doesn't understand the arg $p"
        fi
    done

    echo exec ${argv0:+-a \"$argv0\"} \""$original"\" \
         "$flagsBefore" '"$@"' >> "$wrapper"

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
