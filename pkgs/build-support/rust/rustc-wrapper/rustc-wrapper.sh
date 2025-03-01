#!@shell@

defaultSysroot=(@sysroot@)

for arg; do
    case "$arg" in
        --sysroot|--sysroot=*)
            defaultSysroot=()
            ;;
        --)
            break
            ;;
    esac
done

extraBefore=(@defaultArgs@ "${defaultSysroot[@]}")
extraAfter=($@extraFlagsVar@)

# Optionally print debug info.
if (( "${NIX_DEBUG:-0}" >= 1 )); then
    echo "extra flags before to @prog@:" >&2
    printf "  %q\n" "${extraBefore[@]}" >&2
    echo "original flags to @prog@:" >&2
    printf "  %q\n" "$@" >&2
    echo "extra flags after to @prog@:" >&2
    printf "  %q\n" "${extraAfter[@]}" >&2
fi

export NIX_LDFLAGS="@ldflags@ $NIX_LDFLAGS"
exec @prog@ "${extraBefore[@]}" "$@" "${extraAfter[@]}"
