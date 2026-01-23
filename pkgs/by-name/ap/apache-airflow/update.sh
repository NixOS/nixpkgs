#!/usr/bin/env nix-shell
#!nix-shell -i bash -p common-updater-scripts curl jq nixfmt-tree

set -euo pipefail

# This script updates apache-airflow to the latest tag for a given major version.
# It defaults to major version 3.
#
# Usage: ./update.sh [MAJOR_VERSION]
# Example: ./update.sh 2

MAJOR_VERSION="${1:-3}"
PACKAGE_DIR=$(dirname "$0")
PACKAGE_NAME="apache-airflow"

# Fetches the latest git tag for the given major version from the GitHub API.
# It filters for tags that look like version numbers and sorts them to find the latest.
get_latest_tag() {
    TEMP_FILE=$(mktemp)
    curl -s "https://api.github.com/repos/apache/airflow/releases" > "$TEMP_FILE"
    LATEST_TAG=$(jq -r --arg major_version "$MAJOR_VERSION" '
        .[]
        | select(.tag_name | test("^" + $major_version + "\\.\\d+\\.\\d+$"))
        | .tag_name
    ' "$TEMP_FILE" | sort -V | tail -n 1)
    rm "$TEMP_FILE"
    echo "$LATEST_TAG"
}

echo "Looking for latest tag for major version $MAJOR_VERSION..."
LATEST_TAG=$(get_latest_tag)

if [[ -z "$LATEST_TAG" ]]; then
    echo "No new tag found for major version $MAJOR_VERSION."
    exit 0
fi

echo "Latest tag found: $LATEST_TAG"

# Update the version and hash in the package definition
# This uses the standard nixpkgs script `update-source-version`.
echo "Updating source version for $PACKAGE_NAME to $LATEST_TAG..."
update-source-version "$PACKAGE_NAME" "$LATEST_TAG"

# After updating the main package, run the providers update script.
# It will automatically pick up the new version from the nix file.
echo "Updating provider dependencies..."
"$PACKAGE_DIR/update-providers.py"
echo "Formatting generated providers.nix"
treefmt "$PACKAGE_DIR"

echo "Update complete. Please check the git diff for changes."

