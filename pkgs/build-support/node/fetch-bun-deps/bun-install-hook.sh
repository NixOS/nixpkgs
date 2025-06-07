#!/usr/bin/env bash
# shellcheck shell=bash

bunInstallHook() {
    echo "Executing bunInstallHook"

    runHook preInstall

    # shellcheck disable=SC2154
    # SC2154: $out is referenced but not assigned
    # $out is a standard Nix environment variable representing the output path for the derivation
    local -r packageOut="$out/lib/node_modules/$(@jq@ --raw-output '.name' ./package.json)"
    mkdir -p "$packageOut"

    local -ar bunArgs=(
        --no-progress
        --no-save
        --offline
    )

    local tmpDir
    tmpDir="$(mktemp -d)"
    local -r tmpDir

    # Pack the package (equivalent to yarn pack in Bun)
    bun pack \
        --out-file "$tmpDir/bun-pack.tgz" \
        "${bunArgs[@]}"

    tar xzf "$tmpDir/bun-pack.tgz" \
        -C "$packageOut" \
        --strip-components 1 \
        package/

    nodejsInstallExecutables ./package.json

    nodejsInstallManuals ./package.json

    local -r nodeModulesPath="$packageOut/node_modules"

    if [ ! -d "$nodeModulesPath" ]; then
        if [ -z "${bunKeepDevDeps-}" ]; then
            # Install production dependencies only
            if ! bun install \
                --frozen-lockfile \
                --production \
                "${bunArgs[@]}"
            then
                echo
                echo
                echo "ERROR: bun production install step failed"
                echo
                echo "If bun tried to download additional dependencies above, try setting \`bunKeepDevDeps = true\`."
                echo

                exit 1
            fi
        fi

        find node_modules -maxdepth 1 -type d -empty -delete

        cp -r node_modules "$nodeModulesPath"
    fi

    runHook postInstall

    echo "Finished bunInstallHook"
}

if [ -z "${dontBunInstall-}" ] && [ -z "${installPhase-}" ]; then
    installPhase=bunInstallHook
fi
