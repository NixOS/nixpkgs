{ pname
, version
, homepage
, lib
, gitUpdater
, writers
, jq
, yq
}:

let
  updater = gitUpdater {
    inherit pname version;
    attrPath = lib.toLower pname;
    rev-prefix = "v";
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
  ${jq}/bin/jq '. + {
      dependencies: (.dependencies + .devDependencies),
    } | del(.devDependencies, .main, .scripts)' \
    "$SRC/client/package.json" \
    > client/package.json

  # Regenerate node packages to update the pre-overriden epgstation derivation.
  # This must come *after* package.json has been regenerated.
  pushd ../../../development/node-packages
  ./generate.sh
  popd

  # Generate default streaming settings for the nixos module.
  pushd ../../../../nixos/modules/services/video/epgstation
  ${yq}/bin/yq -j '{ urlscheme , stream }' \
    "$SRC/config/config.yml.template" \
    > streaming.json

  # Fix generated output for EditorConfig compliance
  printf '\n' >> streaming.json  # rule: insert_final_newline
  popd
''
