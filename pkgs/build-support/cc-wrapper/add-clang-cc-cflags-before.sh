needsTarget=true
targetValue=""

for p in "${params[@]}"; do
    case "$p" in
    -target)
        needsTarget=false
        targetValue=$2
        shift 2
        ;;
    --target=*)
        needsTarget=false
        targetValue="${p#*=}"
        ;;
    esac
done

if ! $needsTarget && [[ "$targetValue" != "@defaultTarget@" ]]; then
    echo "Warning: supplying the --target argument to a nix-wrapped compiler may not work correctly - cc-wrapper is currently not designed with multi-target compilers in mind. You may want to use an un-wrapped compiler instead." >&2
fi

if $needsTarget && [[ $0 != *cpp ]]; then
    extraBefore+=(-target @defaultTarget@ @machineFlags@)
fi
