# shellcheck shell=bash

npmInstallHook() {
    echo "Executing npmInstallHook"

    runHook preInstall

    if ! @jq@ -e 'select(.name) | any' package.json; then
        echo
        echo
        echo "ERROR: missing \"name\" field in package.json"
        echo
        echo "Here are some ways to fix this:"
        echo
        echo "- Add a \"name\" field to your package.json file (with jq: jq '. + {\"name\": \"my-package\"}' package.json | sponge package.json)"
        echo "- Use a custom \"installPhase\" hook to install the package"
        echo
        echo

        exit 1
    fi

    local -r packageOut="$out/lib/node_modules/$(@jq@ --raw-output '.name' package.json)"

    # `npm pack` writes to cache so temporarily override it
    while IFS= read -r file; do
        local dest="$packageOut/$(dirname "$file")"
        mkdir -p "$dest"
        cp "${npmWorkspace-.}/$file" "$dest"
    done < <(@jq@ --raw-output '.[0].files | map(.path) | join("\n")' <<< "$(npm_config_cache="$HOME/.npm" npm pack --json --dry-run --loglevel=warn --no-foreground-scripts ${npmWorkspace+--workspace=$npmWorkspace} $npmPackFlags "${npmPackFlagsArray[@]}" $npmFlags "${npmFlagsArray[@]}")")

    # Based on code from Python's buildPythonPackage wrap.sh script, for
    # supporting both the case when makeWrapperArgs is an array and a
    # IFS-separated string.
    #
    # TODO: remove the string branch when __structuredAttrs are used.
    if [[ "${makeWrapperArgs+defined}" == "defined" && "$(declare -p makeWrapperArgs)" =~ ^'declare -a makeWrapperArgs=' ]]; then
        local -a user_args=("${makeWrapperArgs[@]}")
    else
        local -a user_args="(${makeWrapperArgs:-})"
    fi
    while IFS=" " read -ra bin; do
        mkdir -p "$out/bin"
        makeWrapper @hostNode@ "$out/bin/${bin[0]}" --add-flags "$packageOut/${bin[1]}" "${user_args[@]}"
    done < <(@jq@ --raw-output '(.bin | type) as $typ | if $typ == "string" then
        .name + " " + .bin
        elif $typ == "object" then .bin | to_entries | map(.key + " " + .value) | join("\n")
        elif $typ == "null" then empty
        else "invalid type " + $typ | halt_error end' "${npmWorkspace-.}/package.json")

    while IFS= read -r man; do
        installManPage "$packageOut/$man"
    done < <(@jq@ --raw-output '(.man | type) as $typ | if $typ == "string" then .man
        elif $typ == "list" then .man | join("\n")
        elif $typ == "null" then empty
        else "invalid type " + $typ | halt_error end' "${npmWorkspace-.}/package.json")

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

        cp -r node_modules "$nodeModulesPath"
    fi

    runHook postInstall

    echo "Finished npmInstallHook"
}

if [ -z "${dontNpmInstall-}" ] && [ -z "${installPhase-}" ]; then
    installPhase=npmInstallHook
fi
