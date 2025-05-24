# shellcheck shell=bash

npmInstallHook() {
    echo "Executing npmInstallHook"

    runHook preInstall

    local -r packageName="$(@jq@ --raw-output '.name' "${npmWorkspace-.}/package.json")"
    local -r packageOut="$out/lib/node_modules/$packageName"

    # `npm pack` writes to cache so temporarily override it
    while IFS= read -r file; do
        local dest="$packageOut/$(dirname "$file")"
        mkdir -p "$dest"
        cp "${npmWorkspace-.}/$file" "$dest"
    done < <(@jq@ --raw-output '.[0].files | map(.path | select(. | startswith("node_modules/") | not)) | .[]' <<< "$(npm_config_cache="$HOME/.npm" npm pack --json --dry-run --loglevel=warn --no-foreground-scripts ${npmWorkspace+--workspace=$npmWorkspace} $npmPackFlags "${npmPackFlagsArray[@]}" $npmFlags "${npmFlagsArray[@]}")")

    nodejsInstallExecutables "${npmWorkspace-.}/package.json"

    nodejsInstallManuals "${npmWorkspace-.}/package.json"

    local -r nodeModulesPath="$packageOut/node_modules"

    if [ ! -d "$nodeModulesPath" ]; then
        if [ -z "${dontNpmPrune-}" ]; then
            if ! npm prune --omit=dev --no-save ${npmWorkspace+--workspace=$npmWorkspace} $npmPruneFlags "${npmPruneFlagsArray[@]}" $npmFlags "${npmFlagsArray[@]}"; then
              echo
              echo
              echo "ERROR: npm prune step failed"
              echo
              echo 'If npm tried to download additional dependencies above, try setting `dontNpmPrune = true`.'
              echo

              exit 1
            fi
        fi

        find node_modules -maxdepth 1 -type d -empty -delete

        # FIXME: after npm prune so the workspace package doesn't get turned back into a symlink
        find node_modules -type l | while read -r link; do
            target=$(readlink -f "$link")
            if [ -e "$target" ]; then
                if [[ "$link" == "node_modules/$packageName" ]]; then
                    echo "❌ Removing symlink to self: $link"
                    rm "$link"
                elif [[ "$target" == *"/node_modules/"* ]]; then
                    echo "✅ Keeping internal symlink: $link → $target"
                else
                    echo "📦 Dereferencing external symlink: $link → $target"
                    rm "$link"
                    cp -r "$target" "$link"
                fi
            else
                echo "⚠️ Skipping broken symlink: $link"
            fi
        done

        cp -r node_modules "$nodeModulesPath"
    fi

    runHook postInstall

    echo "Finished npmInstallHook"
}

if [ -z "${dontNpmInstall-}" ] && [ -z "${installPhase-}" ]; then
    installPhase=npmInstallHook
fi
