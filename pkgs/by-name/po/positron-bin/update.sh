#!/usr/bin/env nix-shell
#! nix-shell -i bash -p curl jq git

nixpkgs="$(git rev-parse --show-toplevel)"
positron_nix="$nixpkgs/pkgs/by-name/po/positron-bin/package.nix"

current_version=$(grep -oP "version = \"\K.*\d" $positron_nix)
new_version=$(curl -sSfL \
  -H "Accept: application/vnd.github+json" \
  -H "X-GitHub-Api-Version: 2022-11-28" \
  "https://api.github.com/repos/posit-dev/positron/releases?per_page=1" \
  | jq -r '.[0].name')

if [[ "$new_version" == "$current_version" ]]; then
    echo 'Positron is already up to date'
    exit 0;
fi

# Update Darwin hash.
current_hash=$(nix store prefetch-file --json --hash-type sha256 \
    "https://cdn.posit.co/positron/releases/mac/universal/Positron-${current_version}-universal.dmg" \
    | jq -r .hash)

new_hash=$(nix store prefetch-file --json --hash-type sha256 \
    "https://cdn.posit.co/positron/releases/mac/universal/Positron-${new_version}-universal.dmg" \
    | jq -r .hash)

sed -i "s|$current_hash|$new_hash|g" $positron_nix

# Update Linux x86_64 hash.
current_hash=$(nix store prefetch-file --json --hash-type sha256 \
    "https://cdn.posit.co/positron/releases/deb/x86_64/Positron-${current_version}-x64.deb" \
    | jq -r .hash)

new_hash=$(nix store prefetch-file --json --hash-type sha256 \
    "https://cdn.posit.co/positron/releases/deb/x86_64/Positron-${new_version}-x64.deb" \
    | jq -r .hash)

sed -i "s|$current_hash|$new_hash|g" $positron_nix

# Update Linux aarch64 hash.
current_hash=$(nix store prefetch-file --json --hash-type sha256 \
    "https://cdn.posit.co/positron/releases/deb/arm64/Positron-${current_version}-arm64.deb" \
    | jq -r .hash)

new_hash=$(nix store prefetch-file --json --hash-type sha256 \
    "https://cdn.posit.co/positron/releases/deb/arm64/Positron-${new_version}-arm64.deb" \
    | jq -r .hash)

sed -i "s|$current_hash|$new_hash|g" $positron_nix

# Update version
sed -i "s|$current_version|$new_version|g" $positron_nix
