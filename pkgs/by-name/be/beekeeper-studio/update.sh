#!/usr/bin/env nix-shell
#!nix-shell -i bash -p curl gnused jq nix bash coreutils nix-update common-updater-scripts

set -eou pipefail

latestVersion=$(curl ${GITHUB_TOKEN:+-u ":$GITHUB_TOKEN"} -sL https://api.github.com/repos/beekeeper-studio/beekeeper-studio/releases/latest | jq --raw-output .tag_name | sed 's/^v//')
currentVersion=$(nix eval --raw -f . beekeeper-studio.version)

if [[ "$currentVersion" == "$latestVersion" ]]; then
    echo "package is up-to-date: $currentVersion"
    exit 0
fi

nix-update beekeeper-studio --version "$latestVersion" || true

systems=$(nix eval --json -f . beekeeper-studio.meta.platforms | jq --raw-output '.[]')
for system in $systems; do
    hash=$(nix --extra-experimental-features nix-command hash convert --to sri --hash-algo sha256 $(nix-prefetch-url $(nix eval --raw -f . beekeeper-studio.src.url --system "$system")))
    update-source-version beekeeper-studio $latestVersion $hash --system=$system --ignore-same-version --ignore-same-hash
done
