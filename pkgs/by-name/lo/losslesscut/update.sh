#!/usr/bin/env nix-shell
#!nix-shell -i bash -p bash nix curl coreutils jq nix-update yarn-berry.yarn-berry-fetcher

set -eou pipefail

ROOT="$(dirname "$(readlink -f "$0")")"

latestVersion=$(curl ${GITHUB_TOKEN:+-u ":$GITHUB_TOKEN"} -sL https://api.github.com/repos/mifi/lossless-cut/releases/latest | jq -r '.name')

if [[ "$UPDATE_NIX_OLD_VERSION" == "$latestVersion" ]]; then
    echo "package is up-to-date"
    exit 0
fi

nix-update "$UPDATE_NIX_PNAME" --version "$latestVersion"

src=$(nix-build --no-link "$PWD" -A "$UPDATE_NIX_PNAME.src")
yarn-berry-fetcher missing-hashes "$src/yarn.lock" >"$ROOT/missing-hashes.json"

nix-update "$UPDATE_NIX_PNAME" --version skip
