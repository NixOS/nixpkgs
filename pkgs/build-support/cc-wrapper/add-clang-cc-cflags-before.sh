needsTarget=true

for p in "${params[@]}"; do
    case "$p" in
    -target | --target=*)
        needsTarget=false

        echo "Warning: supplying the --target argument to a nix-wrapped compiler may not work correctly - cc-wrapper is currently not designed with multi-target compilers in mind. You may want to use an un-wrapped compiler instead." >&2
        ;;
    esac
done

if $needsTarget && [[ $0 != *cpp ]]; then
    extraBefore+=(-target @defaultTarget@ @machineFlags@)
fi
