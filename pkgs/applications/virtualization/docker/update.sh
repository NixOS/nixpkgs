#!/usr/bin/env nix-shell
#!nix-shell -i bash -p curl jq nix-prefetch-github gawk

set -euo pipefail

# Updates docker packages (docker_29, docker_30, etc.)
# Fetches component versions from moby's Dockerfile and updates all hashes

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
DEFAULT_NIX="$SCRIPT_DIR/default.nix"

# Determine which docker version to update
ATTR="${1:-${UPDATE_NIX_ATTR_PATH:-docker}}"

# Handle "docker" alias -> use the last docker_XX in the file (latest version)
if [[ "$ATTR" == "docker" ]]; then
    ATTR=$(grep -oE 'docker_[0-9]+' "$DEFAULT_NIX" | tail -1)
fi
ATTR=$(echo "$ATTR" | grep -oE 'docker_[0-9]+' | head -1)

[[ -z "$ATTR" ]] && { echo "Error: Could not determine docker version"; exit 1; }

MAJOR="${ATTR#docker_}"
echo "Updating $ATTR (major version: $MAJOR)"

# Get current and latest versions
CURRENT=$(awk -v a="$ATTR" '$0~a" ="{f=1} f&&/version = "/{match($0,/"[^"]+"/);print substr($0,RSTART+1,RLENGTH-2);exit}' "$DEFAULT_NIX")
LATEST=$(curl -s ${GITHUB_TOKEN:+" -u \":$GITHUB_TOKEN\""} "https://api.github.com/repos/moby/moby/releases" | \
    jq -r --arg m "$MAJOR" '[.[]|select(.tag_name|startswith("docker-v"+$m+"."))|select(.prerelease==false)][0].tag_name|sub("docker-v";"")')

echo "Current: $CURRENT, Latest: $LATEST"
[[ "$CURRENT" == "$LATEST" ]] && { echo "Already up to date!"; exit 0; }

# Fetch component versions from Dockerfile
DOCKERFILE=$(curl -sL "https://raw.githubusercontent.com/moby/moby/docker-v$LATEST/Dockerfile")
RUNC_REV=$(echo "$DOCKERFILE" | sed -n 's/^ARG RUNC_VERSION=//p' | head -1)
CONTAINERD_REV=$(echo "$DOCKERFILE" | sed -n 's/^ARG CONTAINERD_VERSION=//p' | head -1)

echo "Components: runc=$RUNC_REV, containerd=$CONTAINERD_REV"

# Prefetch helper
prefetch() { nix-prefetch-github "$1" "$2" --rev "$3" 2>/dev/null | jq -r '.hash'; }

echo "Prefetching sources..."
CLI_HASH=$(prefetch docker cli "v$LATEST")
MOBY_HASH=$(prefetch moby moby "docker-v$LATEST")
RUNC_HASH=$(prefetch opencontainers runc "$RUNC_REV")
CONTAINERD_HASH=$(prefetch containerd containerd "$CONTAINERD_REV")

# Validate all hashes
for h in "$CLI_HASH" "$MOBY_HASH" "$RUNC_HASH" "$CONTAINERD_HASH"; do
    [[ -z "$h" || "$h" == "null" ]] && { echo "Failed to prefetch a source"; exit 1; }
done

# Update default.nix
echo "Updating $DEFAULT_NIX..."
awk -v attr="$ATTR" -v ver="$LATEST" -v cli="$CLI_HASH" -v moby="$MOBY_HASH" \
    -v runcR="$RUNC_REV" -v runcH="$RUNC_HASH" -v ctrdR="$CONTAINERD_REV" -v ctrdH="$CONTAINERD_HASH" \
    -v old="$CURRENT" '
    $0 ~ attr" =" { in_block=1 }
    in_block && /^  docker_[0-9]/ && $0 !~ attr { in_block=0 }
    in_block && /^}$/ { in_block=0 }
    in_block && /version = "/ { gsub(old, ver) }
    in_block && /cliHash = "sha256-/ { gsub(/sha256-[^"]*/, cli) }
    in_block && /mobyHash = "sha256-/ { gsub(/sha256-[^"]*/, moby) }
    in_block && /runcRev = "/ { gsub(/"v[^"]*"/, "\"" runcR "\"") }
    in_block && /runcHash = "sha256-/ { gsub(/sha256-[^"]*/, runcH) }
    in_block && /containerdRev = "/ { gsub(/"v[^"]*"/, "\"" ctrdR "\"") }
    in_block && /containerdHash = "sha256-/ { gsub(/sha256-[^"]*/, ctrdH) }
    { print }
' "$DEFAULT_NIX" > "$DEFAULT_NIX.tmp" && mv "$DEFAULT_NIX.tmp" "$DEFAULT_NIX"

echo "Updated $ATTR to $LATEST (cli=$CLI_HASH, moby=$MOBY_HASH, runc=$RUNC_REV, containerd=$CONTAINERD_REV)"
