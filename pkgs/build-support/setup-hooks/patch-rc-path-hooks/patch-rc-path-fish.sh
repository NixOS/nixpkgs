patchRcPathFish(){
    local FILE_TO_PATCH="$1"
    local SOURCETIME_PATH="$2"
    local FILE_TO_WORK_ON="$(mktemp "$(basename "$FILE_TO_PATCH").XXXXXX.tmp")"
    cat <<EOF >> "$FILE_TO_WORK_ON"
# Lines to add to PATH the source-time utilities for Nixpkgs packaging
if set -q NIXPKGS_SOURCETIME_PATH && test (count \$NIXPKGS_SOURCETIME_PATH) -gt 0
    set --unpath NIXPKGS_SOURCETIME_PATH_OLD "\$NIXPKGS_SOURCETIME_PATH" \$NIXPKGS_SOURCETIME_PATH_OLD
end
set --path NIXPKGS_SOURCETIME_PATH $SOURCETIME_PATH
set -g --path PATH \$NIXPKGS_SOURCETIME_PATH \$PATH
# End of lines to add to PATH source-time utilities for Nixpkgs packaging
EOF
    cat "$FILE_TO_PATCH" >> "$FILE_TO_WORK_ON"
    cat <<EOF >> "$FILE_TO_WORK_ON"
# Lines to clean up inside PATH the source-time utilities for Nixpkgs packaging
if set -q PATH && test "\$PATH" != "" && test (count \$PATH) -ge (count \$NIXPKGS_SOURCETIME_PATH)
    # Remove the inserted section
    for i in (seq 0 (math (count \$PATH) - (count \$NIXPKGS_SOURCETIME_PATH)))
        for j in (seq 1 (count \$NIXPKGS_SOURCETIME_PATH))
            if test \$PATH[(math \$i + \$j)] != \$NIXPKGS_SOURCETIME_PATH[\$j]
                set i -1
                break
            end
        end
        if test \$i -eq -1
            continue
        end
        if test \$i -eq 0
            set -g --path PATH \$PATH[(math (count \$NIXPKGS_SOURCETIME_PATH) + 1)..]
        else
            set -g --path PATH \$PATH[..\$i] \$PATH[(math (count \$NIXPKGS_SOURCETIME_PATH) + 1 + \$i)..]
        end
        break
    end
end
if set -q NIXPKGS_SOURCETIME_PATH_OLD && test (count \$NIXPKGS_SOURCETIME_PATH_OLD) -gt 0
    set --path NIXPKGS_SOURCETIME_PATH \$NIXPKGS_SOURCETIME_PATH_OLD[1]
    set --unpath NIXPKGS_SOURCETIME_PATH_OLD \$NIXPKGS_SOURCETIME_PATH_OLD[2..]
else
    set -e NIXPKGS_SOURCETIME_PATH
end
if set -q NIXPKGS_SOURCETIME_PATH_OLD && test (count \$NIXPKGS_SOURCETIME_PATH_OLD) -eq 0
    set -e NIXPKGS_SOURCETIME_PATH_OLD
end
# End of lines to clean up inside PATH the source-time utilities for Nixpkgs packaging
EOF
    cat "$FILE_TO_WORK_ON" > "$FILE_TO_PATCH"
    rm "$FILE_TO_WORK_ON"
}
