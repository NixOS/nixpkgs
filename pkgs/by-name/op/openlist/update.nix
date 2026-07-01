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
    oldVersion=$(nix-instantiate --eval --strict -A "openlist.version" | jq -e -r)

    get_latest_release() {
        local repo=$1
        curl --fail ''${GITHUB_TOKEN:+ -H "Authorization: bearer $GITHUB_TOKEN"} \
             -s "https://api.github.com/repos/OpenListTeam/$repo/releases/latest" | jq -r ".tag_name"
    }

    get_github_commit_date() {
        local repo=$1
        local rev=$2

        curl --fail ''${GITHUB_TOKEN:+ -H "Authorization: bearer $GITHUB_TOKEN"} \
             -s "https://api.github.com/repos/OpenListTeam/$repo/commits/$rev" \
          | jq -e -r '.commit.committer.date[0:10]'
    }

    get_github_package_version_at_rev() {
        local repo=$1
        local rev=$2

        curl --fail ''${GITHUB_TOKEN:+ -H "Authorization: bearer $GITHUB_TOKEN"} \
             -s "https://raw.githubusercontent.com/OpenListTeam/$repo/$rev/package.json" \
          | jq -e -r '.version'
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

    frontendLockFile="$(nix-build --no-out-link -A openlist.frontend.src)/pnpm-lock.yaml"
    mpegtsRev=$(sed -nE 's/.*github:OpenListTeam\/mpegts\.js#([0-9a-f]{40}).*/\1/p' "$frontendLockFile"| head -n1)
    mpegtsBaseVersion=$(get_github_package_version_at_rev "mpegts.js" "$mpegtsRev")
    mpegtsDate=$(get_github_commit_date "mpegts.js" "$mpegtsRev")

    update-source-version openlist.frontend.mpegts-js "$mpegtsBaseVersion-unstable-$mpegtsDate" \
      --rev="$mpegtsRev" \
      --file=pkgs/by-name/op/openlist/frontend.nix
    nix-update openlist.frontend.mpegts-js \
      --version=skip \
      --override-filename=pkgs/by-name/op/openlist/frontend.nix

    nix-update openlist --version="$version"
  '';
}
