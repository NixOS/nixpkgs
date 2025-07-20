#!/usr/bin/env nix-shell
#!nix-shell -i bash -p bash nix curl coreutils jq common-updater-scripts

latestTag=$(curl ${GITHUB_TOKEN:+-u ":$GITHUB_TOKEN"} -sL https://api.github.com/repos/mihomo-party-org/mihomo-party/releases/latest | jq -r ".tag_name")
latestVersion="$(expr "$latestTag" : 'v\(.*\)')"
currentVersion=$(nix-instantiate --eval -E "with import ./. {}; mihomo-party.version" | tr -d '"')

echo "latest  version: $latestVersion"
echo "current version: $currentVersion"

if [[ "$latestVersion" == "$currentVersion" ]]; then
    echo "package is up-to-date"
    exit 0
fi

for i in \
    "x86_64-linux amd64" \
    "aarch64-linux arm64"; do
    set -- $i
    prefetch=$(nix-prefetch-url "https://github.com/mihomo-party-org/mihomo-party/releases/download/v$latestVersion/mihomo-party-linux-$latestVersion-$2.deb")
    hash=$(nix --extra-experimental-features nix-command hash convert --hash-algo sha256 --to sri $prefetch)
    update-source-version mihomo-party $latestVersion $hash --system=$1 --ignore-same-version
done
