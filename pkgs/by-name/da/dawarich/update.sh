#!/usr/bin/env nix-shell
#! nix-shell -i bash -p bundix curl jq nix-update
set -e

OWNER="Freika"
REPO="dawarich"

old_version=$(nix-instantiate --eval -A 'dawarich.version' default.nix | tr -d '"' || echo "0.0.1")
version=$(curl -s "https://api.github.com/repos/$OWNER/$REPO/releases/latest" | jq -r ".tag_name")

echo "Updating to $version"

if [[ "$old_version" == "$version" ]]; then
    echo "Already up to date!"
    exit 0
fi

nix-update --version "$version" dawarich

# rm -f gemset.nix source.nix
# cd "$(dirname "${BASH_SOURCE[0]}")" || exit 1


WORK_DIR=$(mktemp -d)

# Check that working directory was created.
if [[ -z "$WORK_DIR" || ! -d "$WORK_DIR" ]]; then
    echo "Could not create temporary directory"
    exit 1
fi


# Delete the working directory on exit.
function cleanup {
    rm -rf "$WORK_DIR"
}
# trap cleanup EXIT

SOURCE_DIR="$(nix-build --no-out-link -A dawarich.src)"
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" &>/dev/null && pwd)"

echo "Creating gemset.nix"
# the Gemfile reads .ruby_version from the cwd, so we need to cd to the src dir
pushd "$SOURCE_DIR"
bundix --lockfile="./Gemfile.lock" --gemfile="./Gemfile" --gemset="$SCRIPT_DIR/gemset.nix"
popd
nixfmt "$SCRIPT_DIR/gemset.nix"
