#!/usr/bin/env nix-shell
#!nix-shell -i bash -p curl gnused jq nix bash coreutils

set -eou pipefail

# Get the directory of the script
PACKAGE_DIR=$(realpath "$(dirname "$0")")
LINUX_NIX_FILE="${PACKAGE_DIR}/linux.nix"
DARWIN_NIX_FILE="${PACKAGE_DIR}/darwin.nix"
PACKAGE_NIX_FILE="${PACKAGE_DIR}/package.nix"

# Fetch the latest version tag from GitHub, removing the 'v' prefix
latestVersion=$(
  curl ${GITHUB_TOKEN:+-u ":$GITHUB_TOKEN"} -sL \
    https://api.github.com/repos/beekeeper-studio/beekeeper-studio/releases/latest |
    jq --raw-output .tag_name |
    sed 's/^v//'
)

# Get the current version from package.nix
currentVersion=$(
  sed -n 's/.*version = "\(.*\)";/\1/p' "$PACKAGE_NIX_FILE" | xargs
)

if [[ "$currentVersion" == "$latestVersion" ]]; then
  echo "Beekeeper Studio is already up-to-date: ${currentVersion}"
  exit 0
fi

echo "Updating Beekeeper Studio from ${currentVersion} to ${latestVersion}"

# 1. Update the version in package.nix
sed -i "s/version = \"${currentVersion}\";/version = \"${latestVersion}\";/" \
  "$PACKAGE_NIX_FILE"

# 2. Update Linux hashes in linux.nix
echo "Updating Linux hashes in ${LINUX_NIX_FILE}..."
for nix_arch in x86_64-linux aarch64-linux; do
  echo "  Fetching hash for ${nix_arch}..."
  deb_arch=$([ "$nix_arch" = "x86_64-linux" ] && echo "amd64" || echo "arm64")
  url="https://github.com/beekeeper-studio/beekeeper-studio/releases/download/v${latestVersion}/beekeeper-studio_${latestVersion}_${deb_arch}.deb"
  hash=$(nix-prefetch-url --type sha256 "$url" | xargs nix hash to-sri --type sha256)
  sed -i "s|\(${nix_arch} = \).*|\1\"${hash}\";|" "$LINUX_NIX_FILE"
  echo "    Done: ${hash}"
done

# 3. Update Darwin hashes in darwin.nix
echo "Updating Darwin hashes in ${DARWIN_NIX_FILE}..."
for nix_arch in x86_64-darwin aarch64-darwin; do
  echo "  Fetching hash for ${nix_arch}..."
  file_part=$([ "$nix_arch" = "x86_64-darwin" ] && echo "mac" || echo "arm64-mac")
  url="https://github.com/beekeeper-studio/beekeeper-studio/releases/download/v${latestVersion}/Beekeeper-Studio-${latestVersion}-${file_part}.zip"
  hash=$(nix-prefetch-url --type sha256 "$url" | xargs nix hash to-sri --type sha256)
  # This sed command targets the sha256 line within the block for the correct architecture
  sed -i "/${nix_arch} = {/,/};/ s|sha256 = \".*\";|sha256 = \"${hash}\";|" \
    "$DARWIN_NIX_FILE"
  echo "    Done: ${hash}"
done

echo "Successfully updated Beekeeper Studio to version ${latestVersion}"
