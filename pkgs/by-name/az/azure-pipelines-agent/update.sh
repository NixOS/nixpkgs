#! /usr/bin/env nix-shell
#! nix-shell -I nixpkgs=./. -i bash -p coreutils common-updater-scripts jq curl

set -euo pipefail

currentVersion="$(nix --extra-experimental-features nix-command eval -f . azure-pipelines-agent.version --raw)"
latestVersion="$(curl -s -H "Accept: application/vnd.github.v3+json" \
  ${GITHUB_TOKEN:+ -H "Authorization: bearer $GITHUB_TOKEN"} \
  "https://api.github.com/repos/microsoft/azure-pipelines-agent/releases/latest" | jq -r ".tag_name")"
latestVersion="${latestVersion#v}" # v4.272.0 -> 4.272.0

if [[ "$latestVersion" == "$currentVersion" ]]; then
  echo "azure-pipelines-agent is already up to date: $currentVersion"
  exit
fi

update-source-version azure-pipelines-agent "$latestVersion"
$(nix-build -A azure-pipelines-agent.fetch-deps --no-out-link)
