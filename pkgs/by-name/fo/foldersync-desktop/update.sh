#!/usr/bin/env nix-shell
#!nix-shell -i bash -p bash curl coreutils jq nix

set -eu -o pipefail

cd "$(dirname "${BASH_SOURCE[0]}")"

latestVersion=$(curl -sSfL https://api.github.com/repos/tacitdynamics/foldersync-desktop-production/releases/latest | jq -r '.tag_name')
currentVersion=$(nix-instantiate --eval -E "with import ../../../.. {}; foldersync-desktop.version" | tr -d '"')

if [[ "$latestVersion" == "$currentVersion" ]]; then
    echo "foldersync-desktop is up-to-date"
    exit 0
fi

echo "Updating foldersync-desktop from $currentVersion to $latestVersion"

# Update the hashes of the sources
for platform in x86_64-linux:linux-amd64:tar.gz aarch64-linux:linux-aarch64:tar.gz x86_64-darwin:mac-amd64:zip aarch64-darwin:mac-aarch64:zip; do
    nixPlatform="${platform%%:*}"
    rest="${platform#*:}"
    fileSuffix="${rest%%:*}"
    ext="${rest##*:}"

    url="https://github.com/tacitdynamics/foldersync-desktop-production/releases/download/${latestVersion}/foldersync-desktop-${latestVersion}-${fileSuffix}.${ext}"
    prefetch=$(nix-prefetch-url "$url")
    hash=$(nix-hash --type sha256 --to-sri "$prefetch")

    sed -i "/${nixPlatform} = {/,/};/ s|hash = \"[^\"]*\";|hash = \"${hash}\";|" ./package.nix
done

# Update the version of the package once the hashes are updated
sed -i "s|version = \"$currentVersion\";|version = \"$latestVersion\";|" ./package.nix

echo "Done"
