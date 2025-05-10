#!/usr/bin/env nix-shell
#!nix-shell -i bash -p curl jq common-updater-scripts

set -eu -o pipefail

api() {
  curl -s "https://dev.azure.com/EverestAPI/Everest/_apis/$1?api-version=7.1"
}

pipeline_id=$(api pipelines | jq -r '
  .value
  | map(select(.name == "EverestAPI.Everest"))
  | .[0].id
')

run_id=$(api pipelines/$pipeline_id/runs | jq -r '
  .value
  | map(select(.result == "succeeded"))
  | max_by(.finishedDate)
  | .id
')
commit=$(api pipelines/$pipeline_id/runs/$run_id | jq -r '.resources.repositories.self.version')
version=$(($run_id + 700))

update-source-version celestegame.passthru.everest $version --rev=$commit
"$(nix-build --attr celestegame.passthru.everest.fetch-deps --no-out-link)"

update-source-version celestegame.passthru.everest-bin $version
