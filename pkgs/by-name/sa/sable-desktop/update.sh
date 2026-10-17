#!/usr/bin/env nix-shell
#!nix-shell -i bash -p common-updater-scripts curl git jq nix-update yq
# shellcheck shell=bash

set -euo pipefail

attr=${UPDATE_NIX_ATTR_PATH:-sable-desktop}
package="$(dirname "$(realpath "${BASH_SOURCE[0]}")")/package.nix"
cd "$(git -C "$(dirname "$package")" rev-parse --show-toplevel)"

# nix-update can't find the stable tags itself: sable-next has no github releases,
# and its nightly tags crowd them out of the tags feed
version=$(list-git-tags --url=https://github.com/SableClient/sable-next |
    grep -E '^v[0-9]+\.[0-9]+\.[0-9]+$' | sort --version-sort | tail -n 1)
nix-update "$attr" --version "${version#v}"

# cef has to match the version after the + of the cef crate in Cargo.lock
src=$(nix-build --no-out-link -A "$attr.src")
cef_version=$(tomlq -er '.package[] | select(.name == "cef") | .version | split("+")[1]' "$src/Cargo.lock")
if [[ "$cef_version" == "$(nix-instantiate --eval --raw -A "$attr.cef.version")" ]]; then
    exit 0
fi

# like cef-binary/update.sh
build=$(curl --silent --fail https://cef-builds.spotifycdn.com/index.json |
    jq -e --arg v "$cef_version" '[.linux64.versions[] | select(.cef_version | startswith($v + "+"))][0]')

update_cef_value() {
    sed -i "/cef = cef-binary.override {/,/};/s|$1 = \".*\"|$1 = \"$2\"|" "$package"
}
update_cef_value version "$(jq -r '.cef_version | split("+")[0]' <<<"$build")"
update_cef_value gitRevision "$(jq -r '.cef_version | split("+")[1] | ltrimstr("g")' <<<"$build")"
update_cef_value chromiumVersion "$(jq -r '.chromium_version' <<<"$build")"

for platform in gnu64 aarch64-multiplatform; do
    nix-update "pkgsCross.$platform.$attr.cef" --version skip --override-filename "$package"
done
