{ gitUpdater
, writers
, jq
, yq
, gnused
, _experimental-update-script-combinators
}:

let
  updateSource = gitUpdater {
    rev-prefix = "v";
  };
  updateLocks = writers.writeBash "update-epgstation" ''
    set -euxo pipefail

    cd "$1"

    # Get the path to the latest source. Note that we can't just pass the value
    # of epgstation.src directly because it'd be evaluated before we can run
    # updateScript.
    SRC="$(nix-build ../../../.. --no-out-link -A epgstation.src)"
    if [[ "$UPDATE_NIX_OLD_VERSION" == "$(${jq}/bin/jq -r .version "$SRC/package.json")" ]]; then
      echo "[INFO] Already using the latest version of $UPDATE_NIX_PNAME" >&2
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

    # Fix issue with old sqlite3 version pinned that depends on very old node-gyp 3.x
    ${gnused}/bin/sed -i -e 's/"sqlite3":\s*"5.0.[0-9]\+"/"sqlite3": "5.0.11"/' package.json

    # Regenerate node packages to update the pre-overridden epgstation derivation.
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
  '';
in
_experimental-update-script-combinators.sequence [
  updateSource
  [updateLocks ./.]
]
