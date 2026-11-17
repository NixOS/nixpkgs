{
  writeShellApplication,
  nix,
  nix-update,
  curl,
  jq,
  common-updater-scripts,
}:

writeShellApplication {
  name = "update-alist";
  runtimeInputs = [
    curl
    jq
    nix
    common-updater-scripts
    nix-update
  ];

  text = ''
    # get old info
    oldVersion=$(nix-instantiate --eval --strict -A "alist.version" | jq -e -r)

    get_latest_release() {
        local repo=$1
        curl --fail ''${GITHUB_TOKEN:+ -H "Authorization: bearer $GITHUB_TOKEN"} \
             -s "https://api.github.com/repos/AlistGo/$repo/releases/latest" | jq -r ".tag_name"
    }

    version=$(get_latest_release "alist")
    version="''${version#v}"
    webVersion=$(get_latest_release "alist-web")

    if [[ "$oldVersion" == "$version" ]]; then
        echo "Already up to date!"
        exit 0
    fi

    update-source-version alist "$webVersion" --source-key=web --version-key=webVersion

    nix-update alist --version="$version"
  '';
}
