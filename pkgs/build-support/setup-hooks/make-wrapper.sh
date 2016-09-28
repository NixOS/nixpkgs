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

        case "$p" in
          "--set")
            varName=${params[$((n + 1))]}
            value=${params[$((n + 2))]}
            n=$((n + 2))
            echo "export $varName=\"$value\"" >> $wrapper
            ;;

          "--unset")
            varName=${params[$((n + 1))]}
            n=$((n + 1))
            echo "unset $varName" >> "$wrapper"
            ;;

          "--run")
            command=${params[$((n + 1))]}
            n=$((n + 1))
            echo "$command" >> $wrapper
            ;;

          "--suffix") ;& # case fallthrough. requires bash >= 4.0
          "--prefix")
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
            ;;

          "--suffix-each")
            varName=${params[$((n + 1))]}
            separator=${params[$((n + 2))]}
            values=${params[$((n + 3))]}
            n=$((n + 3))
            for value in $values; do
                echo "export $varName=\$$varName\${$varName:+$separator}$value" >> $wrapper
            done
            ;;

          "--suffix-contents") ;& # fallthrough
          "--prefix-contents")
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
            ;;

          "--add-flags")
            flags=${params[$((n + 1))]}
            n=$((n + 1))
            flagsBefore="$flagsBefore $flags"
            ;;

          "--argv0")
            argv0=${params[$((n + 1))]}
            n=$((n + 1))
            ;;

          "--*")
            printf "Unknown flag passed to makeWrapper: %s\n" "$p"
            exit 1
            ;;
        esac
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
