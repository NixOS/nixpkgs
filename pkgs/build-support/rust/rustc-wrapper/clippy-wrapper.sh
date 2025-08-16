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

extraAfter=(@defaultArgs@ "${defaultSysroot[@]}" $@extraFlagsVar@)

# Optionally print debug info.
if (( "${NIX_DEBUG:-0}" >= 1 )); then
    echo "original flags to @prog@:" >&2
    printf "  %q\n" "$@" >&2
    echo "extra flags after to @prog@:" >&2
    printf "  %q\n" "${extraAfter[@]}" >&2
fi

exec @prog@ "$@" "${extraAfter[@]}"
