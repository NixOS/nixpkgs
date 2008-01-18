makeWrapper() {
    original=$1
    wrapper=$2

    ensureDir "$(dirname $wrapper)"

    echo "#! $SHELL -e" > $wrapper

    params=("$@")
    for ((n = 2; n < ${#params[*]}; n += 1)); do
        p=${params[$n]}

        if test "$p" = "--set"; then
            varName=${params[$((n + 1))]}
            value=${params[$((n + 2))]}
            n=$((n + 2))
            echo "export $varName=$value" >> $wrapper
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

        if test "$p" = "--suffix-contents"; then
            varName=${params[$((n + 1))]}
            separator=${params[$((n + 2))]}
            fileNames=${params[$((n + 3))]}
            n=$((n + 3))
            for fileName in $fileNames; do
                echo "export $varName=\$$varName\${$varName:+$separator}$(cat $fileName)" >> $wrapper
            done
        fi
    done

    echo "exec \"$original\" \"\$@\"" >> $wrapper
    
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
    local hidden="$(dirname "$prog")/.wrapped-$(basename "$prog")"
    mv $prog $hidden
    makeWrapper $hidden $prog "$@"
}
