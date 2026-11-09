#!/usr/bin/env nix-shell
#!nix-shell -i bash -p common-updater-scripts curl jq nixfmt-tree nix-update

set -euo pipefail

# This script updates apache-airflow to the latest tag for a given major version.
# It defaults to major version 3.
#
# Usage: ./update.sh [MAJOR_VERSION]
# Example: ./update.sh 2

MAJOR_VERSION="${1:-3}"
PACKAGE_DIR=$(dirname "$0")
PACKAGE_NAME="apache-airflow"

CURRENT_VERSION=$(grep -oP 'version = "\K[^"]+' "$PACKAGE_DIR/python-package.nix" | head -n1)

# Fetches the latest git tag for the given major version from the GitHub API.
# It filters for tags that look like version numbers and sorts them to find the latest.
get_latest_tag() {
    local auth_header=()
    if [[ -n "${GITHUB_TOKEN:-}" ]]; then
        auth_header=(-H "Authorization: Bearer $GITHUB_TOKEN")
    fi
    curl -s "${auth_header[@]}" "https://api.github.com/repos/apache/airflow/releases?per_page=100" | jq -r --arg major_version "$MAJOR_VERSION" '
        .[]
        | select(.tag_name | test("^" + $major_version + "\\.\\d+\\.\\d+$"))
        | .tag_name
    ' | sort -V | tail -n 1
}

echo "Current version: $CURRENT_VERSION"
echo "Looking for latest tag for major version $MAJOR_VERSION..."
LATEST_TAG=$(get_latest_tag)

if [[ -z "$LATEST_TAG" ]]; then
    echo "No tag found for major version $MAJOR_VERSION."
    exit 1
fi

echo "Latest tag found: $LATEST_TAG"

if [[ "$CURRENT_VERSION" == "$LATEST_TAG" && "${FORCE:-0}" != "1" ]]; then
    echo "$PACKAGE_NAME is already up to date ($CURRENT_VERSION). Set FORCE=1 to re-run."
    exit 0
fi

# Update the version and hash in the package definition
echo "Updating source version for $PACKAGE_NAME to $LATEST_TAG..."
nix-update --subpackage airflowUi --subpackage airflowSimpleAuthUi "$PACKAGE_NAME" \
  --version "$LATEST_TAG"

# After updating the main package, run the providers update script.
# It will automatically pick up the new version from the nix file.
echo "Updating provider dependencies..."
"$PACKAGE_DIR/update-providers.py"
echo "Formatting generated providers.nix..."
treefmt "$PACKAGE_DIR"

echo "Update complete. Please check the git diff for changes."
