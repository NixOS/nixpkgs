#!/usr/bin/env nix-shell
#!nix-shell -i bash -p curl gnused common-updater-scripts jq prefetch-npm-deps nodejs
set -euo pipefail

version=$(curl ${GITHUB_TOKEN:+" -u \":$GITHUB_TOKEN\""} -s https://api.github.com/repos/microsoft/pyright/releases/latest | jq -r '.tag_name | sub("^v"; "")')

update-source-version pyright "$version"

root="$(dirname "$(readlink -f "$0")")"
FILE_PATH="$root/package.nix"
REPO_URL_PREFIX="https://github.com/microsoft/pyright/raw"
TEMP_DIR=$(mktemp -d)

trap 'rm -rf "$TEMP_DIR"' EXIT

# Function to download `package-lock.json` for a given source path and update hash
update_hash() {
    local source_root_path="$1"
    local existing_hash="$2"

    local package_url="${REPO_URL_PREFIX}/${version}${source_root_path}"
    if [ "$source_root_path" == "" ]; then
        pushd "${TEMP_DIR}"
        curl -fsSL "$package_url/package.json" | jq '
          .devDependencies |= with_entries(select(.key == "glob" or .key == "jsonc-parser"))
          | .scripts =  {  }
        ' > package.json
        npm install --package-lock
        cp package-lock.json "$root/package-lock.json"
        popd
    else
        curl -fsSL -o "${TEMP_DIR}/package-lock.json" "$package_url/package-lock.json"
    fi

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
