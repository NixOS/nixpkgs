#!/usr/bin/env nix-shell
#!nix-shell -i bash -p curl gnused jq nix bash coreutils nix-update common-updater-scripts

set -eou pipefail

PACKAGE_DIR=$(realpath $(dirname $0))

latestVersion=$(curl ${GITHUB_TOKEN:+-u ":$GITHUB_TOKEN"} -sL https://api.github.com/repos/beekeeper-studio/beekeeper-studio/releases/latest | jq --raw-output .tag_name | sed 's/^v//')

currentVersion=$(nix-instantiate --eval -E "with import ./. {}; beekeeper-studio.version or (lib.getVersion beekeeper-studio)" | tr -d '"')

if [[ "$currentVersion" == "$latestVersion" ]]; then
    echo "package is up-to-date: $currentVersion"
    exit 0
fi

nix-update beekeeper-studio --version "$latestVersion" || true

hash=$(nix --extra-experimental-features nix-command hash convert --to sri --hash-algo sha256 $(nix-prefetch-url "$(nix eval -f . --raw beekeeper-studio.src.url --system aarch64-linux)"))
update-source-version beekeeper-studio $latestVersion $hash --system=aarch64-linux --ignore-same-version
