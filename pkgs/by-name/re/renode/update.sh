#!/usr/bin/env nix-shell
#!nix-shell -i bash -p curl jq common-updater-scripts git nix

set -euo pipefail

latest_tag=$(curl -s https://api.github.com/repos/renode/renode/releases/latest | jq -r '.tag_name')
latest_version="${latest_tag#v}"

# Resolve tag to commit hash
# Try dereferenced ref first (annotated tags), then direct ref (lightweight tags)
commit=$(git ls-remote https://github.com/renode/renode "refs/tags/${latest_tag}^{}" | awk '{print $1}')
if [[ -z "$commit" ]]; then
    commit=$(git ls-remote https://github.com/renode/renode "refs/tags/${latest_tag}" | awk '{print $1}')
fi

update-source-version renode "$latest_version" --rev="$commit"

# Regenerate nuget deps
$(nix-build -A renode.passthru.fetch-deps --no-out-link)
