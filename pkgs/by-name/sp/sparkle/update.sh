#!/usr/bin/env nix-shell
#!nix-shell -i bash -p bash nix curl coreutils common-updater-scripts nix-update jq

currentVersion=$(nix-instantiate --eval -E "with import ./. {}; sparkle.version or (lib.getVersion sparkle)" | tr -d '"')
latestVersion=$(curl ${GITHUB_TOKEN:+-u ":$GITHUB_TOKEN"} -sL https://api.github.com/repos/xishang0128/sparkle/releases/latest | jq --raw-output .tag_name)

echo "latest  version: $latestVersion"
echo "current version: $currentVersion"

if [[ "$latestVersion" == "$currentVersion" ]]; then
    echo "package is up-to-date"
    exit 0
fi

nix-update sparkle --version $latestVersion --system x86_64-linux
hash=$(nix --extra-experimental-features nix-command hash convert --to sri --hash-algo sha256 $(nix-prefetch-url $(nix-instantiate --eval -E "with import ./. {}; sparkle.src.url" --system aarch64-linux | tr -d '"')))
update-source-version sparkle $latestVersion $hash --system=aarch64-linux --ignore-same-version
