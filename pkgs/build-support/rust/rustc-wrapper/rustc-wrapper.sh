#!@shell@

# Optionally print debug info.
if (( "${NIX_DEBUG:-0}" >= 1 )); then
    echo "original flags to @prog@:" >&2
    printf "  %q\n" "$@" >&2
    echo "extra flags after to @prog@:" >&2
    printf "  %q\n" $NIX_RUSTFLAGS >&2
fi

exec @prog@ "$@" $NIX_RUSTFLAGS
