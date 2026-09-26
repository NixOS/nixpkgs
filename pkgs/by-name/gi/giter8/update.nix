{
  writeShellApplication,
  coreutils,
  curl,
  git,
  gnused,
  jq,
  nix,
}:

writeShellApplication {
  name = "update-giter8";

  runtimeInputs = [
    coreutils
    curl
    git
    gnused
    jq
    nix
  ];

  text = ''
    # stdout is reserved for the JSON expected by the `commit` updateScript
    # feature, everything else has to go to stderr.
    attr_path="''${UPDATE_NIX_ATTR_PATH:-giter8}"
    nixpkgs=$(git rev-parse --show-toplevel)

    eval_attr() {
      nix-instantiate --eval --json --attr "$attr_path.$1" "$nixpkgs" | jq --raw-output .
    }

    position=$(eval_attr meta.position)
    package_nix="''${position%:*}"
    old_version=$(eval_attr version)
    changelog=$(eval_attr meta.changelog)
    repo=$(sed -n 's|^https://github.com/\([^/]*/[^/]*\)/.*|\1|p' <<< "$changelog")

    if [[ -z "$repo" ]]; then
      echo "could not read a GitHub repository out of meta.changelog: $changelog" >&2
      exit 1
    fi

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
      echo "$package_nix holds an implausible version: '$old_version'" >&2
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

    # The dependency hash is only learnable from the failed build below, so edit
    # first and restore on any failure.
    backup=$(mktemp)
    cp "$package_nix" "$backup"
    trap 'cp "$backup" "$package_nix"; rm -f "$backup"' EXIT

    sed -i "s|version = \"$old_version\"|version = \"$new_version\"|" "$package_nix"

    if build_log=$(nix-build --no-out-link --attr "$attr_path" "$nixpkgs" 2>&1); then
      echo "expected a hash mismatch for the new dependencies, but the build succeeded" >&2
      exit 1
    fi

    new_hash=$(sed -n 's/^[[:space:]]*got:[[:space:]]*\(.*\)$/\1/p' <<< "$build_log" | head -1)

    if [[ ! "$new_hash" =~ ^sha256-[A-Za-z0-9+/=]+$ ]]; then
      echo "could not read the new dependency hash out of the build log:" >&2
      echo "$build_log" >&2
      exit 1
    fi

    sed -i "s|outputHash = \"[^\"]*\"|outputHash = \"$new_hash\"|" "$package_nix"

    nix-build --no-out-link --attr "$attr_path" "$nixpkgs" > /dev/null

    trap - EXIT
    rm -f "$backup"

    jq --null-input --compact-output \
      --arg attrPath "$attr_path" \
      --arg oldVersion "$old_version" \
      --arg newVersion "$new_version" \
      --arg file "$package_nix" \
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
