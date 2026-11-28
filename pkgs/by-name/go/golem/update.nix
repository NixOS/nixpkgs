{
  writeShellApplication,
  nix,
  nix-update,
  curl,
  jq,
  common-updater-scripts,
}:

writeShellApplication {
  name = "update-golem";
  runtimeInputs = [
    curl
    jq
    nix
    common-updater-scripts
    nix-update
  ];

  text = ''
    oldVersion=$(nix-instantiate --eval --strict -A "golem.version" | jq -e -r)

    version=$(curl --fail ''${GITHUB_TOKEN:+ -H "Authorization: bearer $GITHUB_TOKEN"} \
        -s "https://api.github.com/repos/golemcloud/golem/releases/latest" | jq -r ".tag_name")
    version="''${version#v}"

    if [[ "$oldVersion" == "$version" ]]; then
        echo "Already up to date!"
        exit 0
    fi

    # Update version and the built-in artifacts release manifest together:
    # its URL is derived from `version`, so fix the (fixed-output fetchurl)
    # manifest hash before anything evaluates the new version.
    update-source-version golem "$version" --source-key=builtinArtifactsManifest

    # Primary source (tag archive) + cargoHash.
    nix-update golem --version="$version"
  '';
}
