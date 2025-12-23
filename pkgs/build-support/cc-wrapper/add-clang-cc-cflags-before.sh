targetPassed=false
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
        targetPassed=true
        targetValue=$v
        # skip parsing the value of -target
        n+=1
        ;;
    --target=*)
        targetPassed=true
        targetValue="${p#*=}"
        ;;
    esac
done

if $targetPassed && [[ "$targetValue" != "@defaultTarget@" ]] && (( "${NIX_CC_WRAPPER_SUPPRESS_TARGET_WARNING:-0}" < 1 )); then
    echo "Warning: supplying the --target $targetValue != @defaultTarget@ argument to a nix-wrapped compiler may not work correctly - cc-wrapper is currently not designed with multi-target compilers in mind. You may want to use an un-wrapped compiler instead." >&2
elif [[ $0 != *cpp ]]; then
    extraBefore+=(-target @defaultTarget@ @machineFlags@)

    if [[ "@explicitAbiValue@" != "" ]]; then
        extraBefore+=(-mabi=@explicitAbiValue@)
    fi
fi

if [[ "@darwinMinVersion@" ]]; then
    extraBefore+=(-Werror=unguarded-availability)
fi
