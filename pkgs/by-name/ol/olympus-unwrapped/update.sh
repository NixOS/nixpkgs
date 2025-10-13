#!/usr/bin/env nix-shell
#!nix-shell -i bash -p curl jq common-updater-scripts

set -eu -o pipefail

attr=olympus-unwrapped
nix_file=$(nix-instantiate --eval --strict -A "$attr.meta.position" | sed -re 's/^"(.*):[0-9]+"$/\1/')

api() {
  curl -s "https://dev.azure.com/EverestAPI/Olympus/_apis/$1?api-version=7.1"
}

pipeline_id=$(api pipelines | jq -r '
  .value
  | map(select(.name == "EverestAPI.Olympus"))
  | .[0].id
')

run_id=$(api pipelines/$pipeline_id/runs | jq -r '
  .value
  | map(select(.result == "succeeded"))
  | max_by(.finishedDate)
  | .id
')
sed -i 's|buildId\s*=\s*".*";|buildId = "'$run_id'";|' $nix_file

run=$(api pipelines/$pipeline_id/runs/$run_id)
commit=$(echo "$run" | jq -r '.resources.repositories.self.version')
version=$(echo "$run" | jq -r '.name')
update-source-version $attr $version --rev=$commit

"$(nix-build --attr $attr.fetch-deps --no-out-link)"
