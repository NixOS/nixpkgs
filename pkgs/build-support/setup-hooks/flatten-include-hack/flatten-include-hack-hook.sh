# shellcheck shell=bash

# This is a horrible hack. You should not use this.

flattenIncludes() {
    (
        cd "${!outputInclude}/include" || exit
        for file in */*; do
            target=$(basename "$file")
            echo "[HACK] Symlinking include $file to flattened path $target..."
            ln -s "$file" "$target"
        done
    )
}

preFixupHooks+=(flattenIncludes)
