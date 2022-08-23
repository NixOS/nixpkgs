needsTarget=true

for p in "${params[@]}"; do
    case "$p" in
    -target | --target=*) needsTarget=false ;;
    esac
done

if $needsTarget; then
    extraBefore+=(-target @defaultTarget@)
fi
