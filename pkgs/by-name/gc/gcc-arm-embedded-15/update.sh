#!/usr/bin/env nix-shell
#!nix-shell -i bash -p bash curl jq coreutils common-updater-scripts

set -euo pipefail

package=gcc-arm-embedded-15
currentVersion=$(nix-instantiate --eval --strict --json -A "$package.version" | jq -r .)
version=$(
  curl --fail --silent --show-error --location \
    'https://gitlab.arm.com/api/v4/projects/tooling%2Fgnu-toolchains-for-arm/packages?package_type=generic&package_name=gnu-toolchain&order_by=created_at&sort=desc&per_page=100' \
    | jq -r --arg major "${currentVersion%%.*}" \
      '.[] | select(.name == "gnu-toolchain") | .version | select(test("^" + $major + "\\.[0-9]+\\.rel[0-9]+$"))' \
    | sort -V | tail -n 1
)

if [[ -z "$version" ]]; then
  echo "Could not find a release for $package" >&2
  exit 1
fi

systems=(aarch64-darwin aarch64-linux x86_64-linux)
hashes=()

# Fetch all checksums before changing the version or any platform's hash.
for system in "${systems[@]}"; do
  url=$(nix-instantiate --eval --strict --json --system "$system" \
    -E "with import ./. {}; ($package.overrideAttrs {
      version = \"$version\";
      __intentionallyOverridingVersion = true;
    }).src.url" | jq -r .)
  checksum=$(curl --fail --silent --show-error --location "$url.sha256asc")
  read -r hash _ <<< "$checksum"
  if [[ ! "$hash" =~ ^[[:xdigit:]]{64}$ ]]; then
    echo "Invalid SHA-256 checksum for $system" >&2
    exit 1
  fi
  hashes+=("$hash")
done

# Also refresh hashes when the version already matches, to repair partial updates.
for i in "${!systems[@]}"; do
  update-source-version "$package" "$version" "${hashes[$i]}" \
    --system="${systems[$i]}" --ignore-same-version
done
