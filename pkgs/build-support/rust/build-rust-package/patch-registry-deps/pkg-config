for dir in pkg-config-*; do
    [ -d "$dir" ] || continue

    echo "Patching pkg-config registry dep"

    substituteInPlace "$dir/src/lib.rs" \
        --replace '"/usr"' '"'"$NIX_STORE"'/"'
done
