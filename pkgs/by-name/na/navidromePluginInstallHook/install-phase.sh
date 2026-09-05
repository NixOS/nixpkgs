# shellcheck shell=bash disable=SC2154,SC2164

naviPluginInstall() {
  echo "Executing installPhase"

  runHook preInstall

  mkdir -p "$out"/share
  buildDir="$(mktemp -d)"

  find . -type f -name "*.wasm" -exec cp {} "$buildDir/plugin.wasm" \;

  cp manifest.json "$buildDir"

  pushd "$buildDir"

  zip --must-match \
    "$out/share/$pname.ndp" \
    plugin.wasm \
    manifest.json

  popd

  runHook postInstall
}

installPhase=naviPluginInstall
