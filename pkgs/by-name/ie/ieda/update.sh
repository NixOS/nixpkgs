#!/usr/bin/env nix-shell
#!nix-shell -i bash -p curl jq common-updater-scripts

set -eu -o pipefail

latestCommit="$(curl -fs https://gitee.com/api/v5/repos/oscc-project/iEDA/commits?sha=master | jq -r '.[0].sha')"
commitDate="$(curl -fs https://gitee.com/api/v5/repos/oscc-project/iEDA/commits/"$latestCommit" | jq -r '.commit.committer.date[:10]')"
latestReleaseTag="$(curl -fs https://gitee.com/api/v5/repos/oscc-project/iEDA/releases/latest | jq -r '.tag_name | ltrimstr("v")')"

[ "$latestCommit" != "null" ] && [ -n "$latestCommit" ] || { echo "Failed to fetch latest commit"; exit 1; }
[ "$commitDate" != "null" ] && [ -n "$commitDate" ] || { echo "Failed to fetch commit date"; exit 1; }
[ "$latestReleaseTag" != "null" ] && [ -n "$latestReleaseTag" ] || { echo "Failed to fetch release tag"; exit 1; }

newVersion="$latestReleaseTag-unstable-$commitDate"

update-source-version \
  "$UPDATE_NIX_ATTR_PATH" \
  "$newVersion" \
  --rev="$latestCommit" \
  --source-key="src.src"
