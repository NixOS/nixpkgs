patchRcPathBash(){
    local FILE_TO_PATCH="$1"
    local SOURCETIME_PATH="$2"
    local FILE_TO_WORK_ON="$(mktemp "$(basename "$FILE_TO_PATCH").XXXXXX.tmp")"
    cat <<EOF >> "$FILE_TO_WORK_ON"
# Lines to add to PATH the source-time utilities for Nixpkgs packaging
if [[ -n "\${NIXPKGS_SOURCETIME_PATH-}" ]]; then
    NIXPKGS_SOURCETIME_PATH_OLD="\$NIXPKGS_SOURCETIME_PATH;\${NIXPKGS_SOURCETIME_PATH_OLD-}"
fi
NIXPKGS_SOURCETIME_PATH="$SOURCETIME_PATH"
if [[ -n "\$PATH" ]]; then
    PATH="\$NIXPKGS_SOURCETIME_PATH:\$PATH"
else
    PATH="\$NIXPKGS_SOURCETIME_PATH"
fi
export PATH
# End of lines to add to PATH source-time utilities for Nixpkgs packaging
EOF
    cat "$FILE_TO_PATCH" >> "$FILE_TO_WORK_ON"
    cat <<EOF >> "$FILE_TO_WORK_ON"
# Lines to clean up inside PATH the source-time utilities for Nixpkgs packaging
if [[ -n "\${PATH-}" ]]; then
    # Remove the inserted section
    PATH="\${PATH/\$NIXPKGS_SOURCETIME_PATH}"
    # Remove the duplicated colons
    PATH="\${PATH//::/:}"
    # Remove the prefixing colon
    if [[ -n "\$PATH" && "\${PATH:0:1}" == ":" ]]; then
        PATH="\${PATH:1}"
    fi
    # Remove the trailing colon
    if [[ -n "\$PATH" && "\${PATH:\${#PATH}-1}" == ":" ]]; then
        PATH="\${PATH::}"
    fi
    export PATH
fi
if [[ -n "\${NIXPKGS_SOURCETIME_PATH_OLD-}" ]]; then
    IFS="" read -r -d ";" NIXPKGS_SOURCETIME_PATH <<< "\$NIXPKGS_SOURCETIME_PATH_OLD"
    NIXPKGS_SOURCETIME_PATH_OLD="\${NIXPKGS_SOURCETIME_PATH_OLD:\${#NIXPKGS_SOURCETIME_PATH}+1}"
else
    unset NIXPKGS_SOURCETIME_PATH
fi
if [[ -z "\${NIXPKGS_SOURCETIME_PATH_OLD-}" ]]; then
    unset NIXPKGS_SOURCETIME_PATH_OLD
fi
# End of lines to clean up inside PATH the source-time utilities for Nixpkgs packaging
EOF
    cat "$FILE_TO_WORK_ON" > "$FILE_TO_PATCH"
    rm "$FILE_TO_WORK_ON"
}
