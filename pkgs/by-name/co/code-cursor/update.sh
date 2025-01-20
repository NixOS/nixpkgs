#!/usr/bin/env nix-shell
#!nix-shell -i bash -p curl yq coreutils gnused trurl common-updater-scripts
set -eu -o pipefail

baseUrl="https://download.todesktop.com/230313mzl4w4u92"
latestLinux="$(curl -s $baseUrl/latest-linux.yml)"
latestDarwin="$(curl -s $baseUrl/latest-mac.yml)"
linuxVersion="$(echo "$latestLinux" | yq -r .version)"

currentVersion=$(nix-instantiate --eval -E "with import ./. {}; code-cursor.version or (lib.getVersion code-cursor)" | tr -d '"')

if [[ "$linuxVersion" != "$currentVersion" ]]; then
    darwinVersion="$(echo "$latestDarwin" | yq -r .version)"
    if [ "$linuxVersion" != "$darwinVersion" ]; then
        echo "Linux version ($linuxVersion) and Darwin version ($darwinVersion) do not match"
        exit 1
    fi
    version="$linuxVersion"

    linuxFilename="$(echo "$latestLinux" | yq -r '.files[] | .url | select(. | endswith(".AppImage"))' | head -n 1)"
    linuxStem="$(echo "$linuxFilename" | sed -E s/^\(.+build.+\)-[^-]+AppImage$/\\1/)"

    darwinFilename="$(echo "$latestDarwin" | yq -r '.files[] | .url | select(. | endswith(".dmg"))' | head -n 1)"
    darwinStem="$(echo "$darwinFilename" | sed -E s/^\(.+Build[^-]+\)-.+dmg$/\\1/)"

    for platform in  "x86_64-linux" "aarch64-linux" "x86_64-darwin" "aarch64-darwin"; do
        if [ $platform = "x86_64-linux" ]; then
            url="$baseUrl/$linuxStem-x86_64.AppImage"
        elif [ $platform = "aarch64-linux" ]; then
            url="$baseUrl/$linuxStem-arm64.AppImage"
        elif [ $platform = "x86_64-darwin" ]; then
            url="$baseUrl/$darwinStem-x64.dmg"
        elif [ $platform = "aarch64-darwin" ]; then
            url="$baseUrl/$darwinStem-arm64.dmg"
        else
            echo "Unsupported platform: $platform"
            exit 1
        fi

        url=$(trurl --accept-space "$url")
        hash=$(nix-hash --to-sri --type sha256 "$(nix-prefetch-url "$url" --name "cursor-$version")")
        update-source-version code-cursor $version $hash $url --system=$platform --ignore-same-version --source-key="sources.$platform"
    done
fi
