#!/usr/bin/env bash
set -euf -o pipefail
script_dir="$(cd "$(dirname "$0")" && pwd)"
nixify_script="$(nix-build "$script_dir/../../../.." -A gopass-ui.nixifyNodeDeps --no-out-link)"
echo "$nixify_script"
"$nixify_script" "$script_dir" "$@"
