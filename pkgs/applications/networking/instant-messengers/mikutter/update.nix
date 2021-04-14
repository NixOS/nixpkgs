{ lib
, pname
, version
, writers
, bundix
, bundler
, common-updater-scripts
, curl
, jq
}:

let
  binPath = lib.makeBinPath [ bundler bundix curl jq common-updater-scripts ];
in
writers.writeBash "update-mikutter" ''
  set -euxo pipefail

  export PATH="${binPath}''${PATH:+:}$PATH"

  main() {
    local version="$(queryLatestVersion)"
    if [[ "$version" == "${version}" ]]; then
      echo "[INFO] Already using the latest version of ${pname}" >&2
      exit
    fi

    update-source-version "$UPDATE_NIX_ATTR_PATH" "$version"

    cd "${toString ./.}"

    # Get the path to the latest source. Note that we can't just pass the value
    # of mikutter.src directly because it'd be evaluated before we can run
    # updateScript.
    SRC="$(nix-build ../../../../.. --no-out-link -A mikutter.src)"

    if [[ -d deps ]]; then
      rm -rf deps
    fi
    mkdir deps
    cd deps

    tar xvf "$SRC" --strip-components=1
    find . -not -name Gemfile -exec rm {} \;
    find . -type d -exec rmdir -p --ignore-fail-on-non-empty {} \; || true
    bundle lock
    bundix
  }

  queryLatestVersion() {
    curl -sS 'https://mikutter.hachune.net/download.json?count=1' \
      | jq -r '.[].version_string' \
      | head -n1
  }

  main "$@"
''
