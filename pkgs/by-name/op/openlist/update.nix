{
  writeShellApplication,
  nix,
  nix-update,
  curl,
  common-updater-scripts,
  jq,
}:

writeShellApplication {
  name = "update-openlist";
  runtimeInputs = [
    curl
    jq
    nix
    common-updater-scripts
    nix-update
  ];

  text = ''
    # get old info
    oldVersion=$(nix-instantiate --eval --strict -A "openlist.version" | jq -e -r)

    get_latest_release() {
        local repo=$1
        curl --fail ''${GITHUB_TOKEN:+ -H "Authorization: bearer $GITHUB_TOKEN"} \
             -s "https://api.github.com/repos/OpenListTeam/$repo/releases/latest" | jq -r ".tag_name"
    }

    version=$(get_latest_release "OpenList")
    version="''${version#v}"
    frontendVersion=$(get_latest_release "OpenList-Frontend")
    frontendVersion="''${frontendVersion#v}"

    if [[ "$oldVersion" == "$version" ]]; then
        echo "Already up to date!"
        exit 0
    fi

    nix-update openlist.frontend --version="$frontendVersion"
    update-source-version openlist.frontend "$frontendVersion" \
      --source-key=i18n --ignore-same-version \
      --file=pkgs/by-name/op/openlist/frontend.nix

    nix-update openlist --version="$version"
  '';
}
