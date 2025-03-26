needsTarget=true
targetValue=""

declare -i n=0
nParams=${#params[@]}
while (("$n" < "$nParams")); do
    p=${params[n]}
    v=${params[n + 1]:-} # handle `p` being last one
    n+=1

    case "$p" in
    -target)
        if [ -z "$v" ]; then
            echo "Error: -target requires an argument" >&2
            exit 1
        fi
        needsTarget=false
        targetValue=$v
        # skip parsing the value of -target
        n+=1
        ;;
    --target=*)
        needsTarget=false
        targetValue="${p#*=}"
        ;;
    esac
done

if ! $needsTarget && [[ "$targetValue" != "@defaultTarget@" ]]; then
    echo "Warning: supplying the --target $targetValue != @defaultTarget@ argument to a nix-wrapped compiler may not work correctly - cc-wrapper is currently not designed with multi-target compilers in mind. You may want to use an un-wrapped compiler instead." >&2
fi

if $needsTarget && [[ $0 != *cpp ]]; then
    extraBefore+=(-target @defaultTarget@ @machineFlags@)
fi
