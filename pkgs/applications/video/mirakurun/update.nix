{ pname
, version
, homepage
, lib
, common-updater-scripts
, genericUpdater
, writers
, jq
, yarn
, yarn2nix
}:

let
  updater = genericUpdater {
    inherit pname version;
    attrPath = lib.toLower pname;

    # exclude prerelease versions
    versionLister = writers.writeBash "list-mirakurun-versions" ''
      ${common-updater-scripts}/bin/list-git-tags --url=${homepage} \
        | grep '^[0-9]\+\.[0-9]\+\.[0-9]\+$'
    '';
  };
  updateScript = builtins.elemAt updater 0;
  updateArgs = map (lib.escapeShellArg) (builtins.tail updater);
in writers.writeBash "update-mirakurun" ''
  set -euxo pipefail

  WORKDIR="$(mktemp -d)"
  cleanup() {
    rm -rf "$WORKDIR"
  }
  trap cleanup EXIT

  # bump the version
  ${updateScript} ${lib.concatStringsSep " " updateArgs}

  # Get the path to the latest source. Note that we can't just pass the value
  # of mirakurun.src directly because it'd be evaluated before we can run
  # updateScript.
  SRC="$(nix-build "${toString ../../../..}" --no-out-link -A mirakurun.src)"
  if [[ "${version}" == "$(${jq}/bin/jq -r .version "$SRC/package.json")" ]]; then
    echo "[INFO] Already using the latest version of ${pname}" >&2
    exit
  fi

  cd "$WORKDIR"

  cp "$SRC/package.json" package.json
  "${yarn}/bin/yarn" install --ignore-scripts

  "${yarn2nix}/bin/yarn2nix" > "${toString ./.}/yarn.nix"
  cp yarn.lock "${toString ./.}/yarn.lock"
  cp package.json "${toString ./.}/package.json"
''
