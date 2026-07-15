#!/usr/bin/env nix-shell
#!nix-shell -i bash -p common-updater-scripts git
set -euo pipefail
latest_tag=$(list-git-tags --url="https://android.googlesource.com/tools/repo" | sort -V | tail -n1)
latest_tag=${latest_tag##v}
cd "$(git rev-parse --show-toplevel)"
update-source-version git-repo "$latest_tag"
