# shellcheck shell=bash

testDeclaredType() {
    local varName="$1"
    local typeFlag="$2"

    local typeFlagGot

    if ! [[ "$(declare -p "$varName")" =~ ^"declare "(-[^\ ]+)" $varName".* ]]; then
        echo "ERROR: ${name-testDeclaredType}: variable $varName is not declared." >&2
        return 1
    fi

    typeFlagGot="${BASH_REMATCH[1]}"

    if [[ "$typeFlag" != "$typeFlagGot" ]]; then
        echo "ERROR: ${name-testDeclaredType}: Unexpected declare type flag of variable $varName. Expect ${typeFlag}, got ${typeFlagGot}." >&2
        return 1
    fi
}

# See https://stackoverflow.com/questions/3685970/check-if-a-bash-array-contains-a-value/8574392#8574392
containsArg() {
    local val="$1"
    shift
    for arg; do
        if [[ "$arg" == "$val" ]]; then
            return 0
        fi
    done
    return 1
}
