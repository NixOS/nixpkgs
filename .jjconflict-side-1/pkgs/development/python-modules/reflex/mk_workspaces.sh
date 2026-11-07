#!/usr/bin/env nix-shell
#! nix-shell --pure -i bash -p nix jq yq
set -euo pipefail

src=$(nix-build . -A python3Packages.reflex.src --no-out-link)
# echo >&2 "src=$src"; exit 0 # DEBUG

declare -A workspaces=()
for workspace_path in "$src"/packages/*; do
  workspace_name=$(tomlq <"$workspace_path/pyproject.toml" '.project.name' -r)
  workspaces["$workspace_path"]="$workspace_name"
done
# printf >&2 "%s\n" "${!workspaces[@]}" ; exit # DEBUG
# printf >&2 "%s\n" "${workspaces[@]}" ; exit # DEBUG

workspace_names_json=$( printf '"%s"\n' "${workspaces[@]}" | jq -s '.' -c )
# jq >&2 . <<<"$workspace_names_json"; exit # DEBUG

for workspace_path in $( printf '%q\n' "${!workspaces[@]}" | sort ); do
  workspace_name="${workspaces["$workspace_path"]}"

  if [[ "$workspace_path" != "$src"/packages/"$workspace_name" ]]; then
    echo "$workspace_name"'.sourceRoot = "${finalAttrs.src.name}/'"${workspace_path#"$src/"}"'";'
  fi

  echo "$workspace_name.dependencies = ["
  tomlq <"$workspace_path/pyproject.toml" \
    --argjson "workspace_names" "$workspace_names_json" \
    '.project.dependencies + (.tool.hatch.build.hooks."reflex-pyi".dependencies // [])
      | map( split("[ !><=]"; null)[0] ) # remove ">= 1.2.3"
      | map( gsub("_"; "-") )            # normalize attrpath/pname
      | unique[]
      | if (. as $dep | $workspace_names|index($dep) != null) then
          "  subPkgs.\(.)"
        elif . == "reflex" then
          "  finalAttrs.finalPackage # reflex"
        else
          "  \(.)"
        end
    ' -r
  echo '];'
done
