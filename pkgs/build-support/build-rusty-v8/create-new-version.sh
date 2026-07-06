#!/usr/bin/env nix-shell
#!nix-shell -i bash -p nix-update

set -euo pipefail

new_v8_major=""
new_v8_version=""

while [[ $# -gt 0 ]]; do
    case "$1" in
        --major)
            new_v8_major="$2"
            shift 2
            ;;
        --version)
            new_v8_version="$2"
            shift 2
            ;;
        *)
            echo "Usage: $0 --major MAJOR --version VERSION" >&2
            exit 1
            ;;
    esac
done

if [[ -z "$new_v8_major" || -z "$new_v8_version" ]]; then
    echo "Usage: $0 --major MAJOR --version VERSION" >&2
    exit 1
fi

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_ROOT="$(cd "$SCRIPT_DIR/../../.." && pwd)"

# Check if rusty-v8_$new_v8_major package already exists
if nix-instantiate --eval -A "rusty-v8_$new_v8_major" &>/dev/null 2>&1; then
    echo "rusty-v8_$new_v8_major already exists in nixpkgs" >&2
    exit 0
fi

echo "Creating rusty-v8_$new_v8_major package..." >&2

rusty_v8_dir="$REPO_ROOT/pkgs/by-name/ru/rusty-v8_$new_v8_major"
mkdir -p "$rusty_v8_dir"

# Use distinct placeholder hashes so nix-update can tell them apart
cat > "$rusty_v8_dir/package.nix" <<EOF
{ buildRustyV8, fetchFromGitHub }:

buildRustyV8 rec {
  version = "0.0.0";
  src = fetchFromGitHub {
    owner = "denoland";
    repo = "rusty_v8";
    tag = "v\${version}";
    fetchSubmodules = true;
    hash = "sha256-AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA=";
  };
  cargoHash = "sha256-AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAB=";
}
EOF

echo "Created $rusty_v8_dir/package.nix with placeholder version and fake hashes" >&2

# Fill in version, src hash, and cargoHash using nix-update.
# --override-filename is needed because nix-update traces 'version' to
# build-rusty-v8/default.nix (where 'inherit version;' is) instead of
# this package's file.
echo "Running nix-update to fill in version, src hash, and cargoHash..." >&2
package_nix="$rusty_v8_dir/package.nix"
if ! nix-update -f "$REPO_ROOT/default.nix" "rusty-v8_$new_v8_major" --version "$new_v8_version" --override-filename "$package_nix" 2>&1; then
    echo "Error: nix-update failed" >&2
    exit 1
fi

echo "rusty-v8_$new_v8_major created with version $new_v8_version" >&2
