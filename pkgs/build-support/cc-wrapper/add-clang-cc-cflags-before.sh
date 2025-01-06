needsTarget=true

for p in "${params[@]}"; do
    case "$p" in
    -target | --target=*) needsTarget=false ;;
    esac
done

if $needsTarget && [[ $0 != *cpp ]]; then
    extraBefore+=(-target @defaultTarget@ @machineFlags@)
fi
