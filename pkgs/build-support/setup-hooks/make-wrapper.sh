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
# --argv0        NAME    : set the name of the executed process to NAME
#                          (if unset or empty, defaults to EXECUTABLE)
# --inherit-argv0        : the executable inherits argv0 from the wrapper.
#                          (use instead of --argv0 '$0')
# --resolve-argv0        : if argv0 doesn't include a / character, resolve it against PATH
# --set          VAR VAL : add VAR with value VAL to the executable's environment
# --set-default  VAR VAL : like --set, but only adds VAR if not already set in
#                          the environment
# --unset        VAR     : remove VAR from the environment
# --chdir        DIR     : change working directory (use instead of --run "cd DIR")
# --run          COMMAND : run command before the executable
# --add-flags    ARGS    : prepend ARGS to the invocation of the executable
#                          (that is, *before* any arguments passed on the command line)
# --append-flags ARGS    : append ARGS to the invocation of the executable
#                          (that is, *after* any arguments passed on the command line)

# --prefix          ENV SEP VAL   : suffix/prefix ENV with VAL, separated by SEP
# --suffix
# --prefix-each     ENV SEP VALS  : like --prefix, but VALS is a list
# --suffix-each     ENV SEP VALS  : like --suffix, but VALS is a list
# --prefix-contents ENV SEP FILES : like --suffix-each, but contents of FILES
#                                   are read first and used as VALS
# --suffix-contents
makeWrapper() { makeShellWrapper "$@"; }
makeShellWrapper() {
    local original="$1"
    local wrapper="$2"
    local params varName value command separator n fileNames
    local argv0 flagsBefore flagsAfter flags

    assertExecutable "$original"

    # Write wrapper code which adds `value` to the beginning or end of
    # the list variable named by `varName`, depending on the `mode`
    # specified.
    #
    # A value which is already part of the list will not be added
    # again. If this is the case and the `suffix` mode is used, the
    # list won't be touched at all. The `prefix` mode will however
    # move the last matching instance of the value to the beginning
    # of the list. Any remaining duplicates of the value will be left
    # as-is.
    addValue() {
        local mode="$1"       # `prefix` or `suffix` to add to the beginning or end respectively
        local varName="$2"    # name of list variable to add to
        local separator="$3"  # character used to separate elements of list
        local value="$4"      # one value, or multiple values separated by `separator`, to add to list

        # Disable file globbing, since bash will otherwise try to find
        # filenames matching the the value to be prefixed/suffixed if
        # it contains characters considered wildcards, such as `?` and
        # `*`. We want the value as is, except we also want to split
        # it on on the separator; hence we can't quote it.
        local reenableGlob=0
        if [[ ! -o noglob ]]; then
            reenableGlob=1
        fi
        set -o noglob

        if [[ -n "$value" ]]; then
            local old_ifs=$IFS
            IFS=$separator

            if [[ "$mode" == '--prefix'* ]]; then
                # Keep the order of the components as written when
                # prefixing; normally, they would be added in the
                # reverse order.
                local tmp=
                for v in $value; do
                    tmp=$v${tmp:+$separator}$tmp
                done
                value="$tmp"
            fi
            for v in $value; do
                {
                    echo "$varName=\${$varName:+${separator@Q}\$$varName${separator@Q}}"               # add separators on both ends unless empty
                    if [[ "$mode" == '--prefix'* ]]; then                                              # -- in prefix mode --
                        echo "$varName=\${$varName/${separator@Q}${v@Q}${separator@Q}/${separator@Q}}" # remove the first instance of the value (if any)
                        echo "$varName=${v@Q}\$$varName"                                               # prepend the value
                    elif [[ "$mode" == '--suffix'* ]]; then                                            # -- in suffix mode --
                        echo "if [[ \$$varName != *${separator@Q}${v@Q}${separator@Q}* ]]; then"       # if the value isn't already in the list
                        echo "    $varName=\$$varName${v@Q}"                                           # append the value
                        echo "fi"
                    else
                        echo "unknown mode $mode!" 1>&2
                        exit 1
                    fi
                    echo "$varName=\${$varName#${separator@Q}}"                                        # remove leading separator
                    echo "$varName=\${$varName%${separator@Q}}"                                        # remove trailing separator
                    echo "export $varName"
                } >> "$wrapper"
            done
            IFS=$old_ifs
        fi

        if (( reenableGlob )); then
            set +o noglob
        fi
    }

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
        elif [[ "$p" == "--chdir" ]]; then
            dir="${params[$((n + 1))]}"
            n=$((n + 1))
            echo "cd ${dir@Q}" >> "$wrapper"
        elif [[ "$p" == "--run" ]]; then
            command="${params[$((n + 1))]}"
            n=$((n + 1))
            echo "$command" >> "$wrapper"
        elif [[ ("$p" == "--suffix") || ("$p" == "--prefix") ]]; then
            varName="${params[$((n + 1))]}"
            separator="${params[$((n + 2))]}"
            value="${params[$((n + 3))]}"
            n=$((n + 3))
            addValue "$p" "$varName" "$separator" "$value"
        elif [[ ("$p" == "--suffix-each") || ("$p" == "--prefix-each") ]]; then
            varName="${params[$((n + 1))]}"
            separator="${params[$((n + 2))]}"
            values="${params[$((n + 3))]}"
            n=$((n + 3))
            for value in $values; do
                addValue "$p" "$varName" "$separator" "$value"
            done
        elif [[ ("$p" == "--suffix-contents") || ("$p" == "--prefix-contents") ]]; then
            varName="${params[$((n + 1))]}"
            separator="${params[$((n + 2))]}"
            fileNames="${params[$((n + 3))]}"
            n=$((n + 3))
            for fileName in $fileNames; do
                contents="$(cat "$fileName")"
                addValue "$p" "$varName" "$separator" "$contents"
            done
        elif [[ "$p" == "--add-flags" ]]; then
            flags="${params[$((n + 1))]}"
            n=$((n + 1))
            flagsBefore="${flagsBefore-} $flags"
        elif [[ "$p" == "--append-flags" ]]; then
            flags="${params[$((n + 1))]}"
            n=$((n + 1))
            flagsAfter="${flagsAfter-} $flags"
        elif [[ "$p" == "--argv0" ]]; then
            argv0="${params[$((n + 1))]}"
            n=$((n + 1))
        elif [[ "$p" == "--inherit-argv0" ]]; then
            # Whichever comes last of --argv0 and --inherit-argv0 wins
            argv0='$0'
        elif [[ "$p" == "--resolve-argv0" ]]; then
            # this is noop in shell wrappers, since bash will always resolve $0
            resolve_argv0=1
        else
            die "makeWrapper doesn't understand the arg $p"
        fi
    done

    echo exec ${argv0:+-a \"$argv0\"} \""$original"\" \
         "${flagsBefore-}" '"$@"' "${flagsAfter-}" >> "$wrapper"

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
wrapProgram() { wrapProgramShell "$@"; }
wrapProgramShell() {
    local prog="$1"
    local hidden

    assertExecutable "$prog"

    hidden="$(dirname "$prog")/.$(basename "$prog")"-wrapped
    while [ -e "$hidden" ]; do
      hidden="${hidden}_"
    done
    mv "$prog" "$hidden"
    makeShellWrapper "$hidden" "$prog" --inherit-argv0 "${@:2}"
}
