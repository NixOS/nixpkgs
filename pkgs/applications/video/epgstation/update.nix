{ pname
, version
, homepage
, lib
, common-updater-scripts
, genericUpdater
, writers
, jq
}:

let
  updater = genericUpdater {
    inherit pname version;
    attrPath = lib.toLower pname;
    rev-prefix = "v";
    versionLister = "${common-updater-scripts}/bin/list-git-tags --url=${homepage}";
  };
  updateScript = builtins.elemAt updater 0;
  updateArgs = map (lib.escapeShellArg) (builtins.tail updater);
in writers.writeBash "update-epgstation" ''
  set -euxo pipefail

  # bump the version
  ${updateScript} ${lib.concatStringsSep " " updateArgs}

  cd "${toString ./.}"

  # Get the path to the latest source. Note that we can't just pass the value
  # of epgstation.src directly because it'd be evaluated before we can run
  # updateScript.
  SRC="$(nix-build ../../../.. --no-out-link -A epgstation.src)"
  if [[ "${version}" == "$(${jq}/bin/jq -r .version "$SRC/package.json")" ]]; then
    echo "[INFO] Already using the latest version of ${pname}" >&2
    exit
  fi

  # Regenerate package.json from the latest source.
  ${jq}/bin/jq '. + {
      dependencies: (.dependencies + .devDependencies),
    } | del(.devDependencies, .main, .scripts)' \
    "$SRC/package.json" \
    > package.json

  # Regenerate node packages to update the pre-overriden epgstation derivation.
  # This must come *after* package.json has been regenerated.
  pushd ../../../development/node-packages
  ./generate.sh
  popd

  # Generate default streaming settings for the nixos module.
  pushd ../../../../nixos/modules/services/video/epgstation
  ${jq}/bin/jq '
    { liveHLS
    , liveMP4
    , liveWebM
    , mpegTsStreaming
    , mpegTsViewer
    , recordedDownloader
    , recordedStreaming
    , recordedHLS
    , recordedViewer
    }' \
    "$SRC/config/config.sample.json" \
    > streaming.json
  popd
''
