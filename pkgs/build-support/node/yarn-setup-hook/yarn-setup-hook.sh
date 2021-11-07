yarnSetupPostPatchHook() {
  echo "Executing yarnSetupPostPatchHook"

  if ! [ -e "$NIX_BUILD_TOP/$sourceRoot/$yarnRoot/yarn.lock" ]; then
    echo "\"$NIX_BUILD_TOP/$sourceRoot/$yarnRoot/yarn.lock\" does not exist, exiting"
    exit 1
  fi

  if [ -e "$offlineCache/yarn.lock" ]; then
    echo "Validating consistency between $NIX_BUILD_TOP/$sourceRoot/$yarnRoot/yarn.lock and $offlineCache/yarn.lock"
    if ! cmp -s "$NIX_BUILD_TOP/$sourceRoot/$yarnRoot/yarn.lock" "$offlineCache/yarn.lock"; then
      echo "yarn.lock changed, you need to update the fetchYarnDeps hash"
      exit 1
    fi
  fi

  (
    cd "$NIX_BUILD_TOP/$sourceRoot/$yarnRoot"
    (
      export HOME=$(mktemp -d)
      set -x

      yarn config --offline set yarn-offline-mirror $offlineCache

      # Do not look up in the registry, but in the offline cache.
      fixup_yarn_lock yarn.lock

      yarn install $yarnFlags
    )

    patchShebangs node_modules
  )
}

postPatchHooks+=(yarnSetupPostPatchHook)
