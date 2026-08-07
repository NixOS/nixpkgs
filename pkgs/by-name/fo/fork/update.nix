{
  writeShellApplication,
  common-updater-scripts,
  curl,
  jq,
  nix,
}:

let
  packageName = "fork";
in
writeShellApplication {
  name = "update-${packageName}";
  runtimeInputs = [
    common-updater-scripts
    curl
    jq
    nix
  ];
  text = ''
    pname="''${UPDATE_NIX_PNAME:-${packageName}}"

    main() {
      old_version="''${UPDATE_NIX_OLD_VERSION:-$(get_version)}"
      new_version="$(get_new_version)"

      if [[ "$new_version" == "$old_version" ]]; then
        exit 0
      fi

      update-source-version "$pname" "$new_version" --print-changes
    }

    get_version() {
      nix-instantiate --raw --eval --strict -A "$pname.version"
    }

    get_new_version() {
      cask_json=$(curl -sL https://formulae.brew.sh/api/cask/fork.json)

      version=$(echo "$cask_json" | jq -r '.version')

      if [[ ! "$version" =~ ^[0-9]+(\.[0-9]+)*$ ]]; then
        exit 1
      fi

      echo "$version"
    }

    main
  '';
}
