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
        curl --fail ''${GITHUB_TOKEN:+ -H "Authorization: bearer $GITHUB_TOKEN"} \
             -s "https://api.github.com/repos/HMCL-dev/HMCL/releases/latest" | jq -r ".tag_name"
    }

    version=$(get_latest_release)
    version="''${version#v-}"

    if [[ "$UPDATE_NIX_OLD_VERSION" == "$version" ]]; then
        echo "Already up to date!"
        exit 0
    fi

    nix-update hmcl --version="$version"
    update-source-version hmcl --source-key=jar --ignore-same-version
    eval "$(nix-build -A hmcl.mitmCache.updateScript)"
  '';
}
