#!/usr/bin/env nix-shell
#!nix-shell -i bash -p bash curl coreutils jq common-updater-scripts

latestTag=$(curl -sSfL ${GITHUB_TOKEN:+-u ":$GITHUB_TOKEN"} https://api.github.com/repos/cloud-fs/cloud-fs.github.io/releases/latest | jq -r ".tag_name")
latestVersion="$(expr "$latestTag" : 'v\(.*\)')"
currentVersion=$(nix-instantiate --eval -E "with import ./. {}; clouddrive2.version" | tr -d '"')

echo "latest  version: $latestVersion"
echo "current version: $currentVersion"

if [[ "$latestVersion" == "$currentVersion" ]]; then
    echo "package is up-to-date"
    exit 0
fi
for i in \
    "x86_64-linux linux-x86_64" \
    "aarch64-linux linux-aarch64" \
    "x86_64-darwin macos-x86_64" \
    "aarch64-darwin macos-aarch64"; do
    set -- $i
    prefetch=$(nix-prefetch-url "https://github.com/cloud-fs/cloud-fs.github.io/releases/download/v$latestVersion/clouddrive-2-$2-$latestVersion.tgz")
    hash=$(nix-hash --type sha256 --to-sri $prefetch)

    update-source-version clouddrive2 $latestVersion $hash --system=$1 --ignore-same-version
done
