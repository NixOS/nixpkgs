makeWrapper() {
    original=$1
    wrapper=$2

    ensureDir "$(dirname $wrapper)"

    echo "#! $SHELL -e" > $wrapper

    params=("$@")
    for ((n = 2; n < ${#params[*]}; n += 1)); do
        p=${params[$n]}

        if test "$p" = "--suffix"; then
            echo FOOBAR
            varName=${params[$((n + 1))]}
            separator=${params[$((n + 2))]}
            value=${params[$((n + 3))]}
            n=$((n + 3))
            echo "export $varName=\$$varName\${$varName:+$separator}$value" >> $wrapper
        fi
    done

    echo "exec \"$original\" \"\$@\"" >> $wrapper
    
    chmod +x $wrapper
}
