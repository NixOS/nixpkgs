skip () {
    if test "$NIX_DEBUG" = "1"; then
        echo "skipping impure path $1" >&2
    fi
}


# Checks whether a path is impure.  E.g., `/lib/foo.so' is impure, but
# `/nix/store/.../lib/foo.so' isn't.
badPath() {
    local p=$1
    
    # Relative paths are okay (since they're presumably relative to
    # the temporary build directory).
    if test "${p:0:1}" != "/"; then return 1; fi
    
    # Otherwise, the path should refer to the store or some temporary
    # directory (including the build directory).
    test \
        "$p" != "/dev/null" -a \
        "${p:0:${#NIX_STORE}}" != "$NIX_STORE" -a \
        "${p:0:4}" != "/tmp" -a \
        "${p:0:${#NIX_BUILD_TOP}}" != "$NIX_BUILD_TOP"
}


# Iterates through the passed array, looking for @file arguments and return a
# new array containing the arguments from @file if the file exists.
#
# NOTE: This function has a side-effect of writing to the $params array, and
# returns 0 if expansion was needed and 1 if it wasn't necessary.
expandResponseFileArgs() {
    if test -e "@out@/nix-support/expand-response-files"; then
        for arg in "$@"; do
            if test "${arg:0:1}" = "@" -a -e "${arg:1}"; then
                eval "$("@out@/nix-support/expand-response-files" "$@")"
                return 0
            fi
        done
    fi
    params=("$@")
    return 1
}

# Poor man's character escaping of ' and \, because we don't have sed available.
# Roughly does the same as sed -e 's/[\\'\'']/\\&/g'.
escapeResponseFileArg() {
    local input="$1"
    local output=""
    local i=0

    while [ $i -lt ${#input} ]; do
        if [[ ${input:$i} =~ ([^\\\']*)([\\\']) ]]; then #'])]]# Vim workaround
            output="$output${BASH_REMATCH[1]}\\${BASH_REMATCH[2]}"
            i=$(($i + ${#BASH_REMATCH}))
        else
            output="$output${input:$i}"
            break
        fi
    done

    echo "$output"
}

# Run command (passed as the first argument) with the arguments afterwards put
# into a temporary file which then is appended with @tempfale to the command and
# remove the temporary file afterwards.
runWithExpandedArgs() {
    local program="$1"
    shift
    if local response="$(mktemp --tmpdir build-response.XXXXXXXXXX)"; then
        trap "@coreutils@/bin/rm -f '$response'" EXIT
        for arg in "$@"; do
            echo -E "'$(escapeResponseFileArg "$arg")'" >> "$response"
        done
        "$program" "@$response"
        ret=$?
        @coreutils@/bin/rm -f "$response"
        trap - EXIT
    else
        "$program" "$@"
        ret=$?
    fi
    return $ret
}
