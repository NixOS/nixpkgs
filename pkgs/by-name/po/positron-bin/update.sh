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
    "https://github.com/posit-dev/positron/releases/download/${current_version}/Positron-${current_version}.dmg" \
    | jq -r .hash)

new_hash=$(nix store prefetch-file --json --hash-type sha256 \
    "https://github.com/posit-dev/positron/releases/download/${new_version}/Positron-${new_version}.dmg" \
    | jq -r .hash)

sed -i "s|$current_hash|$new_hash|g" $positron_nix

# Update Linux hash.
current_hash=$(nix store prefetch-file --json --hash-type sha256 \
    "https://github.com/posit-dev/positron/releases/download/${current_version}/Positron-${current_version}.deb" \
    | jq -r .hash)

new_hash=$(nix store prefetch-file --json --hash-type sha256 \
    "https://github.com/posit-dev/positron/releases/download/${new_version}/Positron-${new_version}.deb" \
    | jq -r .hash)

sed -i "s|$current_hash|$new_hash|g" $positron_nix

# Update version
sed -i "s|$current_version|$new_version|g" $positron_nix

# Attempt to build.
export NIXPKGS_ALLOW_UNFREE=1

if ! nix-build -A positron-bin "$nixpkgs"; then
  echo "The updated positron-bin failed to build."
  exit 1
fi

# Commit changes
git add "$positron_nix"
git commit -m "positron-bin: ${current_version} -> ${new_version}"
