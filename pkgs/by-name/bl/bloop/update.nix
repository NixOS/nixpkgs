{
  writeShellApplication,
  coreutils,
  curl,
  git,
  jq,
  nix,
}:

writeShellApplication {
  name = "update-bloop";

  runtimeInputs = [
    coreutils
    curl
    git
    jq
    nix
  ];

  text = ''
    # stdout is reserved for the JSON expected by the `commit` updateScript
    # feature, everything else has to go to stderr.
    attr_path="''${UPDATE_NIX_ATTR_PATH:-bloop}"

    nixpkgs=$(git rev-parse --show-toplevel)
    position=$(nix-instantiate --eval --json --attr "$attr_path.meta.position" "$nixpkgs" \
      | jq --raw-output .)

    # Everything else is read out of the file that is about to be rewritten.
    sources_json="$(dirname "''${position%:*}")/sources.json"
    repo=$(jq --raw-output .repo "$sources_json")
    old_version=$(jq --raw-output .version "$sources_json")

    auth=()
    if [[ -n "''${GITHUB_TOKEN:-}" ]]; then
      auth=(--header "Authorization: Bearer $GITHUB_TOKEN")
    fi

    release=$(curl --silent --show-error --fail "''${auth[@]}" \
      "https://api.github.com/repos/$repo/releases/latest")
    new_version=$(jq --raw-output '.tag_name // "" | ltrimstr("v")' <<< "$release")

    # both versions end up inside Nix expressions below
    version_pattern='^[0-9][0-9A-Za-z.+-]*$'

    if [[ ! "$new_version" =~ $version_pattern ]]; then
      echo "$repo published an implausible version: '$new_version'" >&2
      exit 1
    fi

    if [[ ! "$old_version" =~ $version_pattern ]]; then
      echo "$sources_json holds an implausible version: '$old_version'" >&2
      exit 1
    fi

    order=$(nix-instantiate --eval \
      --expr "builtins.compareVersions \"$new_version\" \"$old_version\"")

    case "$order" in
      0)
        echo "$attr_path is already at the latest version $new_version." >&2
        echo '[]'
        exit 0
        ;;
      -1)
        echo "refusing to downgrade $attr_path from $old_version to $new_version." >&2
        exit 1
        ;;
    esac

    # An asset that disappeared would otherwise surface as a bare 404 from
    # nix-prefetch-url further down.
    known=$(jq '[ to_entries[] | .value | objects | .[].asset ]' "$sources_json")
    missing=$(jq --raw-output --argjson published "$(jq '[ .assets[].name ]' <<< "$release")" \
      '[ .[] | select(IN($published[]) | not) ] | join(", ")' <<< "$known")

    if [[ -n "$missing" ]]; then
      echo "v$new_version does not ship $missing, listed in $sources_json" >&2
      exit 1
    fi

    prefetch() {
      local hash
      hash=$(nix-prefetch-url --type sha256 \
        "https://github.com/$repo/releases/download/v$new_version/$1")

      nix-hash --to-sri --type sha256 "$hash"
    }

    # <section> -> { "<key>": { asset, hash }, ... } for each key in that section
    collect() {
      local section="$1"
      local objects=()
      local key asset hash

      while read -r key; do
        asset=$(jq --raw-output --arg section "$section" --arg key "$key" \
          '.[$section][$key].asset' "$sources_json")
        hash=$(prefetch "$asset")

        objects+=("$(jq --null-input --compact-output \
          --arg key "$key" \
          --arg asset "$asset" \
          --arg hash "$hash" \
          '{ ($key): { asset: $asset, hash: $hash } }')")
      done < <(jq --raw-output --arg section "$section" '.[$section] | keys[]' "$sources_json")

      if [[ ''${#objects[@]} -eq 0 ]]; then
        echo '{}'
        return
      fi

      printf '%s\n' "''${objects[@]}" | jq --slurp add
    }

    # Every object-valued key is a section of { <key>: { asset, hash } }, repo
    # and version being strings. Which sections exist is therefore data too.
    sections='{}'

    while read -r section; do
      entries=$(collect "$section")
      sections=$(jq --arg section "$section" --argjson entries "$entries" \
        '. + { ($section): $entries }' <<< "$sections")
    done < <(jq --raw-output 'to_entries[] | select(.value | type == "object") | .key' "$sources_json")

    # Write beside the target and move into place, so that a failure cannot
    # leave a truncated sources.json and an unbuildable package behind.
    tmp=$(mktemp "$sources_json.XXXXXX")
    trap 'rm -f "$tmp"' EXIT

    jq --null-input \
      --arg repo "$repo" \
      --arg version "$new_version" \
      --argjson sections "$sections" \
      '{ repo: $repo, version: $version } + $sections' \
      > "$tmp"

    chmod --reference="$sources_json" "$tmp"
    mv "$tmp" "$sources_json"

    jq --null-input --compact-output \
      --arg attrPath "$attr_path" \
      --arg oldVersion "$old_version" \
      --arg newVersion "$new_version" \
      --arg file "$sources_json" \
      --arg repo "$repo" \
      '[ {
        attrPath: $attrPath,
        oldVersion: $oldVersion,
        newVersion: $newVersion,
        files: [ $file ],
        commitBody: "https://github.com/\($repo)/releases/tag/v\($newVersion)"
      } ]'
  '';
}
