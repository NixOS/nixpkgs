# shellcheck shell=bash

yarnInstallHook() {
    echo "Executing yarnInstallHook"

    runHook preInstall

    local -r packageOut="$out/lib/node_modules/$(@jq@ --raw-output '.name' ./package.json)"
    mkdir -p "$packageOut"

    local -ar yarnArgs=(
        --ignore-engines
        --ignore-platform
        --ignore-scripts
        --no-progress
        --non-interactive
        --offline
    )

    local -r tmpDir="$(mktemp -d)"

    # yarn pack does not work at all with bundleDependencies.
    # Since we are imediately unpacking, we can just remove them from package.json
    # This will NOT be fixed in yarn v1: https://github.com/yarnpkg/yarn/issues/6794
    mv ./package.json "$tmpDir/package.json.orig"
    # Note: two spellings are accepted, 'bundleDependencies' and 'bundledDependencies'
    @jq@ 'del(.bundleDependencies)|del(.bundledDependencies)' "$tmpDir/package.json.orig" > ./package.json

    # TODO: figure out a way to avoid redundant compress/decompress steps
    yarn pack \
        --filename "$tmpDir/yarn-pack.tgz" \
        "${yarnArgs[@]}"

    tar xzf "$tmpDir/yarn-pack.tgz" \
        -C "$packageOut" \
        --strip-components 1 \
        package/

    mv "$tmpDir/package.json.orig" ./package.json

    nodejsInstallExecutables ./package.json

    nodejsInstallManuals ./package.json

    local -r nodeModulesPath="$packageOut/node_modules"

    if [ ! -d "$nodeModulesPath" ]; then
        if [ -z "${yarnKeepDevDeps-}" ]; then
            # Yarn has a 'prune' command, but it's only a stub that directs you to use install
            if ! yarn install \
                --frozen-lockfile \
                --force \
                --production=true \
                "${yarnArgs[@]}"
            then
              echo
              echo
              echo "ERROR: yarn prune step failed"
              echo
              echo 'If yarn tried to download additional dependencies above, try setting `yarnKeepDevDeps = true`.'
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
