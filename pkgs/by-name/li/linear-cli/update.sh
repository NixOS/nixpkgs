#!/usr/bin/env nix-shell
#!nix-shell -i bash -p curl jq nix nix-update common-updater-scripts

set -eou pipefail

latestVersion=$(curl ${GITHUB_TOKEN:+-u ":$GITHUB_TOKEN"} -sL https://api.github.com/repos/schpet/linear-cli/releases/latest | jq -r .tag_name | sed 's/^v//')
currentVersion=$(nix eval --raw -f . linear-cli.version)

if [[ "$currentVersion" == "$latestVersion" ]]; then
    echo "package is up-to-date: $currentVersion"
    exit 0
fi

nix-update linear-cli --version "$latestVersion" || true

for system in aarch64-darwin x86_64-darwin aarch64-linux x86_64-linux; do
    hash=$(nix --extra-experimental-features nix-command hash convert --to sri --hash-algo sha256 $(nix-prefetch-url $(nix eval --raw -f . linear-cli.src.url --system "$system")))
    update-source-version linear-cli "$latestVersion" "$hash" --system="$system" --ignore-same-version --ignore-same-hash
done
