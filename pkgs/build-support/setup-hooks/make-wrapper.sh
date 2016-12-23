#!bash
# Usage: makeWrapper <original> <wrapper> [OPTIONS]
#
# Builds a wrapper script that executes a number of commands before executing
# the <original> program.
#
# Options:
#
#   --set <name> <value>
#     Adds the given environment variable
#
#   --unset <name>
#     Removes the given environment variable
#
#   --run <command>
#     Adds a pre-command to be executed. It can also be used to append flags
#     to the $extraFlagsArray.
#
#   --suffix, --prefix <name> <separator> <value>
#     Appends / prepends the <value> to the <name> environment variable,
#     separated by the <separator>.
#
#   --suffix-each <name> <separator> "<value1> ..."
#     Appends all the space-separated values to the <name> environment
#     variable, separated by the <separator>.
#
#   --suffix-contents, --prefix-contents <name> <separator> <filename>
#     Appens / prepents the content of <filename> to the <name> environment
#     variable, seprated by the <separator>.
#
#   --add-flags "<flag1> ..."
#     Prepends the space-separated flags to the execution of the program.
#
#   --argv0 <executable>
#     Sets $0 value to <executable> during execution. Useful to hide the
#     .wrapper postfix.
#
makeWrapper() {
    local original=$1
    local wrapper=$2
    local params varName value command separator n fileNames
    local argv0 flagsBefore flags

    mkdir -p "$(dirname $wrapper)"

    echo "#! $SHELL -e" > $wrapper

    params=("$@")
    for ((n = 2; n < ${#params[*]}; n += 1)); do
        p=${params[$n]}

        if test "$p" = "--set"; then
            varName=${params[$((n + 1))]}
            value=${params[$((n + 2))]}
            n=$((n + 2))
            echo "export $varName=\"$value\"" >> $wrapper
        fi

        if test "$p" = "--unset"; then
            varName=${params[$((n + 1))]}
            n=$((n + 1))
            echo "unset $varName" >> "$wrapper"
        fi

        if test "$p" = "--run"; then
            command=${params[$((n + 1))]}
            n=$((n + 1))
            echo "$command" >> $wrapper
        fi

        if test "$p" = "--suffix" -o "$p" = "--prefix"; then
            varName=${params[$((n + 1))]}
            separator=${params[$((n + 2))]}
            value=${params[$((n + 3))]}
            n=$((n + 3))
            if test -n "$value"; then
                if test "$p" = "--suffix"; then
                    echo "export $varName=\$$varName\${$varName:+$separator}$value" >> $wrapper
                else
                    echo "export $varName=$value\${$varName:+$separator}\$$varName" >> $wrapper
                fi
            fi
        fi

        if test "$p" = "--suffix-each"; then
            varName=${params[$((n + 1))]}
            separator=${params[$((n + 2))]}
            values=${params[$((n + 3))]}
            n=$((n + 3))
            for value in $values; do
                echo "export $varName=\$$varName\${$varName:+$separator}$value" >> $wrapper
            done
        fi

        if test "$p" = "--suffix-contents" -o "$p" = "--prefix-contents"; then
            varName=${params[$((n + 1))]}
            separator=${params[$((n + 2))]}
            fileNames=${params[$((n + 3))]}
            n=$((n + 3))
            for fileName in $fileNames; do
                if test "$p" = "--suffix-contents"; then
                    echo "export $varName=\$$varName\${$varName:+$separator}$(cat $fileName)" >> $wrapper
                else
                    echo "export $varName=$(cat $fileName)\${$varName:+$separator}\$$varName" >> $wrapper
                fi
            done
        fi

        if test "$p" = "--add-flags"; then
            flags=${params[$((n + 1))]}
            n=$((n + 1))
            flagsBefore="$flagsBefore $flags"
        fi

        if test "$p" = "--argv0"; then
            argv0=${params[$((n + 1))]}
            n=$((n + 1))
        fi
    done

    # Note: extraFlagsArray is an array containing additional flags
    # that may be set by --run actions.
    echo exec ${argv0:+-a $argv0} "$original" \
         $flagsBefore '"${extraFlagsArray[@]}"' '"$@"' >> $wrapper

    chmod +x $wrapper
}

addSuffix() {
    suffix=$1
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
    local hidden="$(dirname "$prog")/.$(basename "$prog")"-wrapped
    mv $prog $hidden
    makeWrapper $hidden $prog --argv0 '"$0"' "$@"
}
