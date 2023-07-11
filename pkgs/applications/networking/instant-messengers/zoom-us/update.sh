#!/usr/bin/env nix-shell
#!nix-shell -i bash -p common-updater-scripts curl jq

set -eu -o pipefail

scriptDir=$(cd "${BASH_SOURCE[0]%/*}" && pwd)
nixpkgs=$(realpath "$scriptDir"/../../../../..)

echo >&2 "=== Obtaining version data from https://zoom.us/rest/download ..."
linux_data=$(curl -Ls 'https://zoom.us/rest/download?os=linux' | jq .result.downloadVO)
mac_data=$(curl -Ls 'https://zoom.us/rest/download?os=mac' | jq .result.downloadVO)

version_aarch64_darwin=$(jq -r .zoomArm64.version <<<"$mac_data")
version_x86_64_darwin=$(jq -r .zoom.version <<<"$mac_data")
version_x86_64_linux=$(jq -r .zoom.version <<<"$linux_data")

echo >&2 "=== Downloading packages and computing hashes..."
# We precalculate the hashes before calling update-source-version
# because it attempts to calculate each architecture's package's hash
# by running `nix-build --system <architecture> -A zoom-us.src` which
# causes cross compiling headaches; using nix-prefetch-url with
# hard-coded URLs is simpler.  Keep these URLs in sync with the ones
# in default.nix where `srcs` is defined.
hash_aarch64_darwin=$(nix hash to-sri --type sha256 $(nix-prefetch-url --type sha256 "https://zoom.us/client/${version_aarch64_darwin}/zoomusInstallerFull.pkg?archType=arm64"))
hash_x86_64_darwin=$(nix hash to-sri --type sha256 $(nix-prefetch-url --type sha256 "https://zoom.us/client/${version_x86_64_darwin}/zoomusInstallerFull.pkg"))
hash_x86_64_linux=$(nix hash to-sri --type sha256 $(nix-prefetch-url --type sha256 "https://zoom.us/client/${version_x86_64_linux}/zoom_x86_64.pkg.tar.xz"))

echo >&2 "=== Updating default.nix ..."
# update-source-version expects to be at the root of nixpkgs
(cd "$nixpkgs" && update-source-version zoom-us "$version_aarch64_darwin" $hash_aarch64_darwin --system=aarch64-darwin --version-key=versions.aarch64-darwin)
(cd "$nixpkgs" && update-source-version zoom-us "$version_x86_64_darwin" $hash_x86_64_darwin --system=x86_64-darwin --version-key=versions.x86_64-darwin)
(cd "$nixpkgs" && update-source-version zoom-us "$version_x86_64_linux" $hash_x86_64_linux --system=x86_64-linux --version-key=versions.x86_64-linux)

echo >&2 "=== Done!"
