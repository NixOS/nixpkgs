#!/usr/bin/env nix-shell
#!nix-shell -i bash -p curl gnused jq nix bash coreutils nix-update yarn-berry.yarn-berry-fetcher

set -eou pipefail

PACKAGE_DIR=$(realpath $(dirname $0))

latestTag=$(curl ${GITHUB_TOKEN:+-u ":$GITHUB_TOKEN"} -sL https://api.github.com/repos/ebkr/r2modmanPlus/releases/latest | jq --raw-output .tag_name)
latestVersion=$(echo "$latestTag" | sed 's/^v//')

currentVersion=$(nix-instantiate --eval -E "with import ./. {}; r2modman.version or (lib.getVersion r2modman)" | tr -d '"')

if [[ "$currentVersion" == "$latestVersion" ]]; then
    echo "package is up-to-date: $currentVersion"
    exit 0
fi

nix-update r2modman --version "$latestVersion" || true

export HOME=$(mktemp -d)
src=$(nix-build --no-link $PWD -A r2modman.src)
WORKDIR=$(mktemp -d)
cp --recursive --no-preserve=mode $src/* $WORKDIR
pushd $WORKDIR
yarn-berry-fetcher missing-hashes yarn.lock >$PACKAGE_DIR/missing-hashes.json
popd

nix-update r2modman --version skip || true
