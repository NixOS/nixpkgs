#!/usr/bin/env nix-shell
#!nix-shell -i bash -p curl dpkg gnugrep gnused coreutils jq nix
# shellcheck shell=bash

set -euo pipefail

nixpkgs="$(git rev-parse --show-toplevel)"
path="$nixpkgs/pkgs/by-name/in/intune-portal/package.nix"
repository_root="https://packages.microsoft.com/ubuntu"
package_path="prod/pool/main/i/intune-portal"

old_ubuntu_version=$(sed -nE 's/^[[:space:]]*ubuntuVersion = "([^"]+)";.*/\1/p' "$path")
old_version=$(sed -nE 's/^[[:space:]]*version = "([^"]+)";.*/\1/p' "$path")

# update-source-version cannot discover or update the Ubuntu repository version,
# so inspect every published Ubuntu repository and update both fields together.
mapfile -t ubuntu_versions < <(
    curl -fsSL "$repository_root/" \
        | sed -nE 's@.*href="([0-9]+\.[0-9]+)/".*@\1@p' \
        | sort -Vr
)

new_ubuntu_version=""
new_version=""
new_upstream_version=""

for ubuntu_version in "${ubuntu_versions[@]}"; do
    if ! package_index=$(curl -fsSL "$repository_root/$ubuntu_version/$package_path/" 2>/dev/null); then
        continue
    fi

    while IFS= read -r candidate; do
        candidate_upstream_version="${candidate%%-*}"
        if [[ -z "$new_version" ]] || dpkg --compare-versions "$candidate_upstream_version" gt "$new_upstream_version"; then
            new_ubuntu_version="$ubuntu_version"
            new_version="$candidate"
            new_upstream_version="$candidate_upstream_version"
        fi
    done < <(
        printf '%s\n' "$package_index" \
            | sed -nE 's@.*href="intune-portal_([^"]+)_amd64\.deb".*@\1@p'
    )
done

if [[ -z "$new_ubuntu_version" || -z "$new_version" ]]; then
    echo "Error: Could not resolve an Intune Portal release" >&2
    exit 1
fi

if [[ "$old_ubuntu_version" == "$new_ubuntu_version" && "$old_version" == "$new_version" ]]; then
    echo "Current Ubuntu $old_ubuntu_version package $old_version is up-to-date"
    exit 0
fi

url="$repository_root/$new_ubuntu_version/$package_path/intune-portal_${new_version}_amd64.deb"
new_hash=$(nix store prefetch-file --json "$url" | jq -er .hash)

echo "Updating intune-portal: Ubuntu $old_ubuntu_version/$old_version -> Ubuntu $new_ubuntu_version/$new_version"

sed -i \
    -e "s|ubuntuVersion = \"$old_ubuntu_version\";|ubuntuVersion = \"$new_ubuntu_version\";|" \
    -e "s|version = \"$old_version\";|version = \"$new_version\";|" \
    -e "s|hash = \"sha256-[^\"]*\";|hash = \"$new_hash\";|" \
    "$path"

echo "Updated intune-portal to Ubuntu $new_ubuntu_version package $new_version"
