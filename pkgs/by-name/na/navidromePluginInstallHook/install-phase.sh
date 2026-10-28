# shellcheck shell=bash disable=SC2154,SC2164

naviPluginInstall() {
  echo "Executing installPhase"

  runHook preInstall

  mkdir -p "$out/share/plugins"
  buildDir="$(mktemp -d)"

  find . -type f -name "*.wasm" -exec cp {} "$buildDir/plugin.wasm" \;

  cp manifest.json "$buildDir" || {
    echo "manifest.json for the plugin must be in the root of the build directory"
    exit 1
  }

  pushd "$buildDir"

  zip --must-match \
    "$out/share/plugins/$bundleName.ndp" \
    plugin.wasm \
    manifest.json

  popd

  runHook postInstall
}

installPhase=naviPluginInstall
