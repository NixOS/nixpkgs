#!/usr/bin/env nix-shell
#!nix-shell -i bash -p jq curl common-updater-scripts

set -exuo pipefail

SCRIPT_DIR=$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" &> /dev/null && pwd)

# Extract metadata using a single nix-instantiate call with builtins.toJSON
METADATA=$(nix-instantiate --eval --expr "let src = (import ./. {}).backrest.src; in builtins.toJSON { inherit (src) owner repo; rev = if src ? tag then src.tag else src.rev; }" | jq -r fromjson)

OWNER=$(echo "$METADATA" | jq -r .owner)
REPO=$(echo "$METADATA" | jq -r .repo)
REV=$(echo "$METADATA" | jq -r .rev)

SETTINGS_URL="https://raw.githubusercontent.com/$OWNER/$REPO/$REV/webui/project.inlang/settings.json"
echo "Fetching inlang settings from $SETTINGS_URL" >&2

MODULES=$(curl -s "$SETTINGS_URL" | jq -r '.modules[]')

# Initialize an empty JSON object
PLUGINS_JSON="{}"

for remote_url in $MODULES; do
    echo "Processing $remote_url..." >&2

    final_url="$remote_url"

    # Matches: https://cdn.jsdelivr.net/npm/((@[^/]+/[^@/]+|[^@/]+)@([^/]+))(/.*)?$
    #   Group 1: Full identifier (e.g. @scope/pkg@1)
    #   Group 2: Package name (e.g. @scope/pkg or pkg)
    #   Group 3: Version/Tag/Alias (e.g. 4 or latest)
    #   Group 4: Sub-path (e.g. /dist/index.js)
    if [[ $remote_url =~ ^https://cdn.jsdelivr.net/npm/((@[^/]+/[^@/]+|[^@/]+)@([^/]+))(/.*)?$ ]]; then
        pkg_full="${BASH_REMATCH[1]}"
        pkg_name="${BASH_REMATCH[2]}"
        current_ver="${BASH_REMATCH[3]}"
        path="${BASH_REMATCH[4]}"

        # Construct package.json URL to find the exact version
        PKG_JSON_URL="https://cdn.jsdelivr.net/npm/$pkg_name@$current_ver/package.json"
        # echo "  Fetching package.json from $PKG_JSON_URL" >&2

        RESOLVED_VERSION=$(curl -s "$PKG_JSON_URL" | jq -r .version || true)

        if [[ -n "$RESOLVED_VERSION" && "$RESOLVED_VERSION" != "null" ]]; then
            final_url="https://cdn.jsdelivr.net/npm/$pkg_name@$RESOLVED_VERSION$path"
            echo "  Resolved version $RESOLVED_VERSION from package.json" >&2
        fi
    fi

    echo "  Pinned to $final_url" >&2

    hash=$(nix-prefetch-url "$final_url")
    sri=$(nix hash convert --hash-algo sha256 --to sri "$hash")

    # Add to JSON object using jq
    PLUGINS_JSON=$(echo "$PLUGINS_JSON" | jq --arg remote "$remote_url" --arg url "$final_url" --arg hash "$sri" \
        '. + {($remote): {url: $url, hash: $hash}}')
done

echo "$PLUGINS_JSON" | jq . > "$SCRIPT_DIR/inlang-plugins.json"

echo "Updated $SCRIPT_DIR/inlang-plugins.json"
