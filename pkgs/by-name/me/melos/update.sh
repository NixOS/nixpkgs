#!/usr/bin/env nix-shell
#!nix-shell -i bash -p curl jq dart yq-go nix

set -e

# Get the directory where this script is located
script_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# Fetch the latest tags from GitHub
echo "Fetching latest tags from GitHub..." >&2
tags=$(curl -s ${GITHUB_TOKEN:+" -u \":$GITHUB_TOKEN\""} "https://api.github.com/repos/invertase/melos/tags?per_page=20")

if [ -z "$tags" ]; then
  echo "Error: Failed to fetch tags from GitHub" >&2
  exit 1
fi

# Extract the latest stable version tag (skip dev versions)
latest_release=$(echo "$tags" | jq -r '.[] | select(.name | test("^melos-v[0-9]+\\.[0-9]+\\.[0-9]+$")) | .name' | head -1)

if [ -z "$latest_release" ]; then
  echo "Error: Could not find any stable release tags" >&2
  exit 1
fi

new_version=${latest_release#melos-v}

# Get current version from package.nix
current_version=$(grep 'version = ' "$script_dir/package.nix" | head -1 | sed 's/.*version = "\(.*\)".*/\1/')

echo "Current version: $current_version" >&2
echo "Latest version: $new_version" >&2

if [ "$new_version" = "$current_version" ]; then
  echo "Already at latest version" >&2
  exit 0
fi

# Create a temporary directory
tmpdir=$(mktemp -d)
trap "rm -rf $tmpdir" EXIT

echo "Downloading melos ${latest_release} from GitHub..." >&2
archive_url="https://github.com/invertase/melos/archive/refs/tags/${latest_release}.tar.gz"
archive_path="$tmpdir/melos.tar.gz"

if ! curl -sL -o "$archive_path" "$archive_url"; then
  echo "Error: Failed to download archive" >&2
  exit 1
fi

echo "Extracting archive..." >&2
tar -xzf "$archive_path" -C "$tmpdir"

extracted_dir=$(tar -tzf "$archive_path" | head -1 | cut -d/ -f1)
source_dir="$tmpdir/$extracted_dir"

echo "Generating pubspec.lock..." >&2
cd "$source_dir"
dart pub get > /dev/null 2>&1

echo "Converting to JSON..." >&2
yq eval --output-format=json --prettyPrint pubspec.lock > "$tmpdir/pubspec.lock.json"

# Compute the hash from the downloaded archive
echo "Computing source hash..." >&2
nix_hash=$(nix-hash --flat --base32 --type sha256 "$archive_path")
if [ -z "$nix_hash" ]; then
  echo "Error: Failed to compute source hash" >&2
  exit 1
fi
new_hash="sha256-$(nix-hash --to-sri --type sha256 "$nix_hash")"

cp "$tmpdir/pubspec.lock.json" "$script_dir/pubspec.lock.json"
echo "Updated pubspec.lock.json" >&2

# Update version in package.nix
sed -i "s/version = \"[^\"]*\";/version = \"${new_version}\";/" "$script_dir/package.nix"
echo "Updated version to ${new_version}" >&2

# Update hash in package.nix
sed -i "s|hash = \"[^\"]*\";|hash = \"${new_hash}\";|" "$script_dir/package.nix"
echo "Updated hash" >&2

# Output commit message
printf '{
  "attrPath": "melos",
  "oldVersion": "%s",
  "newVersion": "%s",
  "files": ["pubspec.lock.json", "package.nix"],
  "commitMessage": "melos: %s -> %s"
}' "$current_version" "$new_version" "$current_version" "$new_version"
