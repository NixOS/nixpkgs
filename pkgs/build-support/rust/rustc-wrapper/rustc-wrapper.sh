#!@shell@

defaultSysroot=(@sysrootFlag@)
filteredArgs=()

while [[ $# -gt 0 ]]; do
    case "$1" in
        -C)
            if [[ "${2:-}" = "target-feature=+crt-static" ]]; then
                shift 2
                continue
            fi
            ;;
        -Ctarget-feature=+crt-static)
            shift
            continue
            ;;
        --sysroot|--sysroot=*)
            defaultSysroot=()
            ;;
        --)
            filteredArgs+=("$@")
            break
            ;;
    esac
    filteredArgs+=("$1")
    shift
done

extraBefore=("${defaultSysroot[@]}")
extraAfter=(@defaultArgs@ $@extraFlagsVar@)

# Optionally print debug info.
if (( "${NIX_DEBUG:-0}" >= 1 )); then
    echo "extra flags before to @prog@:" >&2
    printf "  %q\n" "${extraBefore[@]}" >&2
    echo "filtered flags to @prog@:" >&2
    printf "  %q\n" "${filteredArgs[@]}" >&2
    echo "extra flags after to @prog@:" >&2
    printf "  %q\n" "${extraAfter[@]}" >&2
fi

exec @prog@ "${extraBefore[@]}" "${filteredArgs[@]}" "${extraAfter[@]}"
