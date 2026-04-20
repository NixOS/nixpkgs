{
  writeShellApplication,
  nix,
  nix-update,
  curl,
  common-updater-scripts,
  jq,
}:

writeShellApplication {
  name = "update-hmcl";
  runtimeInputs = [
    curl
    jq
    nix
    common-updater-scripts
    nix-update
  ];

  text = ''
    get_latest_release() {
        curl -fsSL ''${GITHUB_TOKEN:+ -H "Authorization: bearer $GITHUB_TOKEN"} \
             "https://api.github.com/repos/HMCL-dev/HMCL/releases" | \
        jq -r 'map(select(.tag_name | test("^v\\d+\\.\\d+\\.\\d+$")))[0].tag_name'
    }

    version=$(get_latest_release)
    version="''${version#v}"

    if [[ "$UPDATE_NIX_OLD_VERSION" == "$version" ]]; then
        echo "Already up to date!"
        exit 0
    fi

    if ! curl -fsSL "https://docs.hmcl.net/changelog/stable.html" | grep -q "HMCL $version"; then
        echo "Version $version found on GitHub but not yet listed in stable changelog. Skipping."
        exit 0
    fi

    nix-update hmcl --version="$version"
    update-source-version hmcl --source-key=terracottaBundleJava --ignore-same-version
    update-source-version hmcl --source-key=macOSProviderJava --ignore-same-version
  '';
}
