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
    NIXPKGS="$(pwd)"
    PKG_PATH="$NIXPKGS"/pkgs/by-name/al/alist
    oldVersion=$(nix-instantiate --eval --strict -A "alist.version" | jq -e -r)
    oldVendorHash=$(nix-instantiate --eval --strict -A "alist.vendorHash" | jq -e -r )

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

    # TODO: Switch to nix-update after https://github.com/Mic92/nix-update/pull/296
    update-source-version alist "$version" --source-key=src --version-key=version
    vendorHash=$(nix-build --expr 'let src = (import '"$NIXPKGS"' (if (builtins.hasAttr "config" (builtins.functionArgs (import '"$NIXPKGS"'))) then { config.checkMeta = false; overlays = []; } else { }))."alist".goModules; in (src.overrideAttrs or (f: src // f src)) (_: { outputHash = ""; outputHashAlgo = "sha256"; })' --no-link 2>&1 >/dev/null | tail -n3 | grep -F got: | cut -d: -f2- | sed -e 's/^[[:space:]]*//' -e 's/[[:space:]]*$//')

    if [[ "$oldVendorHash" != "$vendorHash" ]]; then
        sed -i "s|$oldVendorHash|$vendorHash|" "$PKG_PATH"/package.nix
    fi

    update-source-version alist "$webVersion" --source-key=web --version-key=webVersion
  '';
}
