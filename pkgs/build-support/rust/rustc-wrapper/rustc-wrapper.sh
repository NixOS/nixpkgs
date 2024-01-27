#!@shell@

defaultSysroot=(@sysroot@)

for arg; do
    case "$arg" in
        --sysroot)
            defaultSysroot=()
            ;;
        --)
            break
            ;;
    esac
done

extraBefore=("${defaultSysroot[@]}")
extraAfter=($NIX_RUSTFLAGS)

# Optionally print debug info.
if (( "${NIX_DEBUG:-0}" >= 1 )); then
    echo "extra flags before to @prog@:" >&2
    printf "  %q\n" "${extraBefore[@]}" >&2
    echo "original flags to @prog@:" >&2
    printf "  %q\n" "$@" >&2
    echo "extra flags after to @prog@:" >&2
    printf "  %q\n" "${extraAfter[@]}" >&2
fi

exec @prog@ "${extraBefore[@]}" "$@" "${extraAfter[@]}"
