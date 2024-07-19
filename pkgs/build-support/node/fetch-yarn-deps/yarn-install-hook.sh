# shellcheck shell=bash

yarnInstallHook() {
    echo "Executing yarnInstallHook"

    runHook preInstall

    local -r packageOut="$out/lib/node_modules/$(@jq@ --raw-output '.name' package.json)"

    # `npm pack` writes to cache so temporarily override it
    while IFS= read -r file; do
        local dest="$packageOut/$(dirname "$file")"
        mkdir -p "$dest"
        cp "$file" "$dest"
    done < <(@jq@ --raw-output '.[0].files | map(.path | select(. | startswith("node_modules/") | not)) | join("\n")' <<< "$(npm_config_cache="$HOME/.npm" npm pack --json --dry-run --loglevel=warn --no-foreground-scripts $npmPackFlags "${npmPackFlagsArray[@]}" $npmFlags "${npmFlagsArray[@]}")")

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
        else "invalid type " + $typ | halt_error end' "package.json")

    while IFS= read -r man; do
        installManPage "$packageOut/$man"
    done < <(@jq@ --raw-output '(.man | type) as $typ | if $typ == "string" then .man
        elif $typ == "list" then .man | join("\n")
        elif $typ == "null" then empty
        else "invalid type " + $typ | halt_error end' "package.json")

    local -r nodeModulesPath="$packageOut/node_modules"

    if [ ! -d "$nodeModulesPath" ]; then
        if [ -z "${dontYarnPrune-}" ]; then
            # Yarn has a 'prune' command, but it's only a stub that directs you to use install
            if ! yarn install \
                --frozen-lockfile \
                --force \
                --production=true \
                --ignore-engines \
                --ignore-platform \
                --ignore-scripts \
                --no-progress \
                --non-interactive \
                --offline
            then
              echo
              echo
              echo "ERROR: yarn prune step failed"
              echo
              echo 'If yarn tried to download additional dependencies above, try setting `dontYarnPrune = true`.'
              echo

              exit 1
            fi
        fi

        find node_modules -maxdepth 1 -type d -empty -delete

        cp -r node_modules "$nodeModulesPath"
    fi

    runHook postInstall

    echo "Finished yarnInstallHook"
}

if [ -z "${dontYarnInstall-}" ] && [ -z "${installPhase-}" ]; then
    installPhase=yarnInstallHook
fi
