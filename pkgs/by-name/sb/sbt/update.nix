{
  writeShellApplication,
  common-updater-scripts,
  coreutils,
  git,
  gnugrep,
  gnused,
  jq,
  nix,
}:

writeShellApplication {
  name = "update-sbt";

  runtimeInputs = [
    common-updater-scripts
    coreutils
    git
    gnugrep
    gnused
    jq
    nix
  ];

  text = ''
    # stdout is reserved for the JSON expected by the `commit` updateScript
    # feature, everything else has to go to stderr.
    #
    # $UPDATE_NIX_ATTR_PATH is deliberately ignored: sbt-with-scala-native is
    # sbt.overrideAttrs and so inherits this passthru, but its meta.position
    # points at its own file while the version lives here.
    attr_path=sbt
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

    # Version-sorted tags rather than the releases/latest endpoint, which orders
    # by publication date. sbt keeps 1.x and 2.x alive at once and ships them on
    # the same day -- v2.0.6 and v1.12.15 both landed 2026-08-07 -- so the most
    # recently published release is not the newest version.
    #
    # The X.Y.Z filter drops the release candidates: sbt does mark them
    # prerelease on GitHub, but tags carry no such flag and v2.1.0-RC1 would
    # otherwise sort above v2.0.6.
    new_version=$(git -c 'versionsort.suffix=-' ls-remote --exit-code --refs \
      --sort='version:refname' --tags "https://github.com/$repo.git" 'v*' \
      | cut --delimiter='/' --fields=3 \
      | sed 's/^v//' \
      | grep -E '^[0-9]+\.[0-9]+\.[0-9]+$' \
      | tail --lines=1)

    if [[ -z "$new_version" ]]; then
      echo "no plain vX.Y.Z tag found in $repo" >&2
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

    url="https://github.com/$repo/releases/download/v$new_version/sbt-$new_version.tgz"
    hash=$(nix-hash --to-sri --type sha256 "$(nix-prefetch-url "$url")")

    # update-source-version edits in place with `sed -i.cmp` and only removes
    # that backup when it succeeds, so a failure would otherwise leave both a
    # half-edited package.nix and a stray package.nix.cmp behind.
    backup=$(mktemp)
    cp "$package_nix" "$backup"
    trap 'cp "$backup" "$package_nix"; rm --force "$backup" "$package_nix.cmp"' EXIT

    update-source-version "$attr_path" "$new_version" "$hash" >&2

    trap - EXIT
    rm --force "$backup"

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
