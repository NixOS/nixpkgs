# shellcheck shell=bash

npmInstallHook() {
    echo "Executing npmInstallHook"

    runHook preInstall

    # `npm pack` writes to cache
    npm config delete cache

    local -r packageOut="$out/lib/node_modules/$(@jq@ --raw-output '.name' package.json)"

    while IFS= read -r file; do
        local dest="$packageOut/$(dirname "$file")"
        mkdir -p "$dest"
<<<<<<< HEAD
        cp "${npmWorkspace-.}/$file" "$dest"
    done < <(@jq@ --raw-output '.[0].files | map(.path) | join("\n")' <<< "$(npm pack --json --dry-run ${npmWorkspace+--workspace=$npmWorkspace} $npmPackFlags "${npmPackFlagsArray[@]}" $npmFlags "${npmFlagsArray[@]}")")
=======
        cp "$file" "$dest"
    done < <(@jq@ --raw-output '.[0].files | map(.path) | join("\n")' <<< "$(npm pack --json --dry-run $npmPackFlags "${npmPackFlagsArray[@]}" $npmFlags "${npmFlagsArray[@]}")")
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

    while IFS=" " read -ra bin; do
        mkdir -p "$out/bin"
        makeWrapper @hostNode@ "$out/bin/${bin[0]}" --add-flags "$packageOut/${bin[1]}"
    done < <(@jq@ --raw-output '(.bin | type) as $typ | if $typ == "string" then
        .name + " " + .bin
        elif $typ == "object" then .bin | to_entries | map(.key + " " + .value) | join("\n")
<<<<<<< HEAD
        else "invalid type " + $typ | halt_error end' "${npmWorkspace-.}/package.json")

    while IFS= read -r man; do
        installManPage "$packageOut/$man"
    done < <(@jq@ --raw-output '(.man | type) as $typ | if $typ == "string" then .man
        elif $typ == "list" then .man | join("\n")
        else "invalid type " + $typ | halt_error end' "${npmWorkspace-.}/package.json")
=======
        else "invalid type " + $typ | halt_error end' package.json)
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

    local -r nodeModulesPath="$packageOut/node_modules"

    if [ ! -d "$nodeModulesPath" ]; then
<<<<<<< HEAD
        if [ -z "${dontNpmPrune-}" ]; then
            npm prune --omit=dev --no-save ${npmWorkspace+--workspace=$npmWorkspace} $npmPruneFlags "${npmPruneFlagsArray[@]}" $npmFlags "${npmFlagsArray[@]}"
        fi

=======
        npm prune --omit dev --no-save $npmInstallFlags "${npmInstallFlagsArray[@]}" $npmFlags "${npmFlagsArray[@]}"
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
        find node_modules -maxdepth 1 -type d -empty -delete

        cp -r node_modules "$nodeModulesPath"
    fi

    runHook postInstall

    echo "Finished npmInstallHook"
}

if [ -z "${dontNpmInstall-}" ] && [ -z "${installPhase-}" ]; then
    installPhase=npmInstallHook
fi
