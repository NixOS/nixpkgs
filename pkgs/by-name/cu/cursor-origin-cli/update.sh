#!/usr/bin/env nix-shell
#!nix-shell -i bash -p curl common-updater-scripts nix

set -euo pipefail

installer=$(curl -fsSL https://downloads.cursor.com/origin/install.sh)
latest_block=$(sed -n '/^latest)$/,/^  esac$/p' <<< "$installer")
version=$(sed -n 's/^  version="\([^"]*\)"/\1/p' <<< "$latest_block")

if [[ -z "$version" ]]; then
  echo "Could not determine the latest Cursor Origin version" >&2
  exit 1
fi

current_version=$(nix eval --raw -f . cursor-origin-cli.version)
if [[ "$version" == "$current_version" ]]; then
  echo "cursor-origin-cli is already up to date at $current_version"
  exit 0
fi

declare -A upstream_platforms=(
  [aarch64-darwin]="darwin-arm64"
  [aarch64-linux]="linux-arm64"
  [x86_64-linux]="linux-x64"
)

for platform in "${!upstream_platforms[@]}"; do
  upstream_platform=${upstream_platforms[$platform]}
  url=$(awk -v platform="$upstream_platform" '
    $0 == "  " platform ")" { found = 1 }
    found && /url=/ { sub(/^.*url="/, ""); sub(/"$/, ""); print; exit }
  ' <<< "$latest_block")
  sha256=$(awk -v platform="$upstream_platform" '
    $0 == "  " platform ")" { found = 1 }
    found && /sha=/ { sub(/^.*sha="/, ""); sub(/"$/, ""); print; exit }
  ' <<< "$latest_block")

  if [[ -z "$url" || -z "$sha256" ]]; then
    echo "Could not determine the URL and hash for $upstream_platform" >&2
    exit 1
  fi

  hash=$(nix hash convert --hash-algo sha256 --to sri "$sha256")
  update-source-version cursor-origin-cli "$version" "$hash" "$url" \
    --system="$platform" \
    --source-key="sources.$platform" \
    --ignore-same-version
done
