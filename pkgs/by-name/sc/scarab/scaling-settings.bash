# Keep existing value if it is already non-empty
if [[ -z "${AVALONIA_GLOBAL_SCALE_FACTOR-}" ]] && command -v gsettings >/dev/null; then
    echo 'Attempting to get GNOME desktop interface scaling factor' >&2
    AVALONIA_GLOBAL_SCALE_FACTOR="$(gsettings get org.gnome.desktop.interface scaling-factor)"
    AVALONIA_GLOBAL_SCALE_FACTOR="${AVALONIA_GLOBAL_SCALE_FACTOR##* }"
fi

if [[ "${AVALONIA_GLOBAL_SCALE_FACTOR-}" == "0" ]]; then
    echo 'Unset invalid scaling value' >&2
    unset AVALONIA_GLOBAL_SCALE_FACTOR
fi

if [[ -z "${AVALONIA_GLOBAL_SCALE_FACTOR-}" ]] && command -v xrdb >/dev/null; then
    echo 'Attempting to get scaling factor from X FreeType DPI setting' >&2
    dpi="$(xrdb -get Xft.dpi)"
    if [[ -n "${dpi}" ]]; then
        AVALONIA_GLOBAL_SCALE_FACTOR=$(echo "scale=2; ${dpi}/96" | bc)
    fi
fi

if [[ -n "${AVALONIA_GLOBAL_SCALE_FACTOR-}" ]]; then
    echo "Applying scale factor: ${AVALONIA_GLOBAL_SCALE_FACTOR}" >&2
    export AVALONIA_GLOBAL_SCALE_FACTOR
fi
