patchRcPathCsh(){
    local FILE_TO_PATCH="$1"
    local SOURCETIME_PATH="$2"
    local FILE_TO_WORK_ON="$(mktemp "$(basename "$FILE_TO_PATCH").XXXXXX.tmp")"
    cat <<EOF >> "$FILE_TO_WORK_ON"
# Lines to add to PATH the source-time utilities for Nixpkgs packaging
if (\$?NIXPKGS_SOURCETIME_PATH) then
    if ("\$NIXPKGS_SOURCETIME_PATH" != "") then
        if (\$?NIXPKGS_SOURCETIME_PATH_OLD) then
            if ("\$NIXPKGS_SOURCETIME_PATH_OLD" != "")
                set NIXPKGS_SOURCETIME_PATH_OLD = (\$NIXPKGS_SOURCETIME_PATH \$NIXPKGS_SOURCETIME_PATH_OLD)
            else
                set NIXPKGS_SOURCETIME_PATH_OLD = \$NIXPKGS_SOURCETIME_PATH
            endif
        else
            set NIXPKGS_SOURCETIME_PATH_OLD = \$NIXPKGS_SOURCETIME_PATH
        endif
    endif
endif
set NIXPKGS_SOURCETIME_PATH = "$SOURCETIME_PATH"
if (! \$?PATH) then
    setenv PATH ""
endif
if ("\$PATH" != "") then
    setenv PATH "\${NIXPKGS_SOURCETIME_PATH}:\$PATH"
else
    setenv PATH "\$NIXPKGS_SOURCETIME_PATH"
endif
# End of lines to add to PATH source-time utilities for Nixpkgs packaging
EOF
    cat "$FILE_TO_PATCH" >> "$FILE_TO_WORK_ON"
    cat <<EOF >> "$FILE_TO_WORK_ON"
# Lines to clean up inside PATH the source-time utilities for Nixpkgs packaging
if (\$?PATH) then
    if ("\$PATH" != "") then
        # Remove the inserted section, the duplicated colons, and the leading and trailing colon
        setenv PATH \`echo "\$PATH" | @sed@ "s#\${NIXPKGS_SOURCETIME_PATH}##" | @sed@ "s#::#:#g" | @sed@ "s#^:##" | @sed@ 's#:\$##'\`
    endif
endif
if (\$?NIXPKGS_SOURCETIME_PATH_OLD) then
    if ("\$NIXPKGS_SOURCETIME_PATH_OLD" != "") then
        set NIXPKGS_SOURCETIME_PATH = \$NIXPKGS_SOURCETIME_PATH_OLD[1]
        set NIXPKGS_SOURCETIME_PATH_OLD = \$NIXPKGS_SOURCETIME_PATH_OLD[2-]
    else
        unset NIXPKGS_SOURCETIME_PATH
    endif
    if (NIXPKGS_SOURCETIME_PATH_OLD == "") then
        unset NIXPKGS_SOURCETIME_PATH_OLD
    endif
else
    unset NIXPKGS_SOURCETIME_PATH
endif
# End of lines to clean up inside PATH the source-time utilities for Nixpkgs packaging
EOF
    cat "$FILE_TO_WORK_ON" > "$FILE_TO_PATCH"
    rm "$FILE_TO_WORK_ON"
}
