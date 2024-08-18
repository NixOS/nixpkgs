# shellcheck shell=bash

npmFixupHook() {
    echo "Executing npmFixupHook"

    runHook preFixup

    local -r packageOut="$out/lib/node_modules/$(@jq@ --raw-output '.name' package.json)"
    local -r nodeModulesPath="$packageOut/node_modules"

    if [ -d "$nodeModulesPath" ]; then
        pushd "$packageOut"

        if ! npm prune --omit=dev --no-save ${npmWorkspace+--workspace=$npmWorkspace} $npmPruneFlags "${npmPruneFlagsArray[@]}" $npmFlags "${npmFlagsArray[@]}"; then
          echo
          echo
          echo "ERROR: npm prune step failed"
          echo
          echo 'If npm tried to download additional dependencies above, try setting `dontNpmPrune = true`.'
          echo

          exit 1
        fi

        find node_modules -maxdepth 1 -type d -empty -delete

        popd
    fi

    runHook postFixup

    echo "Finished npmFixupHook"
}

# keep dontNpmPrune for backwards compatibility
if [ -z "${dontNpmPrune-}" ] && [ -z "${dontNpmFixup-}" ] && [ -z "${fixupPhase-}" ]; then
    fixupPhase=npmFixupHook
fi
