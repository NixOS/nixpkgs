substitute() {
    input=$1
    output=$2

    params=("$@")

    sedArgs=()
    
    for ((n = 2; n < ${#params[*]}; n += 1)); do
        p=${params[$n]}

        if test "$p" = "--replace"; then
            pattern=${params[$((n + 1))]}
            replacement=${params[$((n + 2))]}
            n=$((n + 2))
            sedArgs=("${sedArgs[@]}" "-e" "s^$pattern^$replacement^g")
        fi

        if test "$p" = "--subst-var"; then
            varName=${params[$((n + 1))]}
            n=$((n + 1))
            sedArgs=("${sedArgs[@]}" "-e" "s^@${varName}@^${!varName}^g")
        fi

    done

    sed "${sedArgs[@]}" < "$input" > "$output".tmp
    if test -x "$output"; then
        chmod +x "$output".tmp
    fi
    mv -f "$output".tmp "$output"
}


substituteInPlace() {
    fileName="$1"
    shift
    substitute "$fileName" "$fileName" "$@"
}
