#!/usr/bin/env nix-shell
#!nix-shell -i bash -p curl gnused common-updater-scripts jq prefetch-npm-deps
set -euo pipefail

version=$(curl ${GITHUB_TOKEN:+" -u \":$GITHUB_TOKEN\""} -v -s https://api.github.com/repos/detachhead/basedpyright/releases/latest | jq -r '.tag_name | sub("^v"; "")')

update-source-version basedpyright "$version"

root="$(dirname "$(readlink -f "$0")")"
FILE_PATH="$root/package.nix"
REPO_URL_PREFIX="https://github.com/detachhead/basedpyright/raw"
TEMP_DIR=$(mktemp -d)

trap 'rm -rf "$TEMP_DIR"' EXIT

# Function to download `package-lock.json` for a given source path and update hash
update_hash() {
    local source_root_path="$1"
    local existing_hash="$2"

    # Formulate download URL
    local download_url="${REPO_URL_PREFIX}/v${version}${source_root_path}/package-lock.json"

    # Download package-lock.json to temporary directory
    curl -fsSL -v -o "${TEMP_DIR}/package-lock.json" "$download_url"

    # Calculate the new hash
    local new_hash
    new_hash=$(prefetch-npm-deps "${TEMP_DIR}/package-lock.json")

    # Update npmDepsHash in the original file
    sed -i "s|$existing_hash|${new_hash}|" "$FILE_PATH"
}

while IFS= read -r source_root_line; do
    [[ "$source_root_line" =~ sourceRoot ]] || continue
    source_root_path=$(echo "$source_root_line" | sed -e 's/^.*"${src.name}\(.*\)";.*$/\1/')

    # Extract the current npmDepsHash for this sourceRoot
    existing_hash=$(grep -A1 "$source_root_line" "$FILE_PATH" | grep 'npmDepsHash' | sed -e 's/^.*npmDepsHash = "\(.*\)";$/\1/')

    # Call the function to download and update the hash
    update_hash "$source_root_path" "$existing_hash"
done < "$FILE_PATH"
