{
  lib,
  stdenv,
  fetchurl,
  autoPatchelfHook,
  writableTmpDirAsHomeHook,
  versionCheckHook,
  writeScript,
}:

let
  version = "1.1.16919734";
  platformData = {
    x86_64-linux = fetchurl {
      url = "https://dl.google.com/android/cli/${version}/linux_x86_64/android-cli";
      hash = "sha256-mAN4Td8k1GmZKe7OUZ/6iwZq+pork71YdJs8bSyq7uw=";
    };
    aarch64-linux = fetchurl {
      url = "https://dl.google.com/android/cli/${version}/linux_arm64/android-cli";
      hash = "sha256-qmCxPQ7yLmci3oVn4GbOYDtasRFX2jsh162I7v4gTD0=";
    };
    aarch64-darwin = fetchurl {
      url = "https://dl.google.com/android/cli/${version}/darwin_arm64/android-cli";
      hash = "sha256-tVnIuHNztDvTtLukVkyICJgcG3S8fhiqQfVb9q88P1s=";
    };
  };

in
stdenv.mkDerivation (finalAttrs: {
  pname = "android-cli";
  inherit version;

  strictDeps = true;
  __structuredAttrs = true;

  src =
    platformData.${stdenv.hostPlatform.system}
      or (throw "Unsupported system: ${stdenv.hostPlatform.system}");

  dontUnpack = true;

  nativeBuildInputs = lib.optionals stdenv.hostPlatform.isLinux [
    autoPatchelfHook
  ];

  buildInputs = lib.optionals (with stdenv.hostPlatform; isLinux && isAarch64) [
    stdenv.cc.cc.lib
  ];

  dontConfigure = true;
  dontBuild = true;

  installPhase = ''
    runHook preInstall
    install -m755 -D $src $out/bin/android
    runHook postInstall
  '';

  nativeInstallCheckInputs = [
    writableTmpDirAsHomeHook
    versionCheckHook
  ];

  doInstallCheck = true;

  versionCheckKeepEnvironment = [ "HOME" ];

  passthru = {
    inherit platformData;
    updateScript = writeScript "updater" ''
      #!/usr/bin/env nix-shell
      #!nix-shell -i bash -p curl gnugrep coreutils common-updater-scripts
      set -eu -o pipefail
      latestVersion="$(curl -sS https://developer.android.com/tools/agents/android-cli/release-notes.md.txt | grep -E "^## Version" | head -n1 | cut -d' ' -f3 | cut -d- -f3-)"
      for platform in ${toString finalAttrs.meta.platforms}; do
        update-source-version android-cli "$latestVersion" --ignore-same-version --source-key=passthru.platformData.$platform
      done
    '';
  };

  meta = with lib; {
    description = "Android Command-Line Tool (CLI) by Google";
    homepage = "https://developer.android.com/tools/agents/android-cli";
    license = licenses.unfree;
    sourceProvenance = with sourceTypes; [ binaryNativeCode ];
    maintainers = with maintainers; [ kirillrdy ];
    teams = with teams; [ android ];
    platforms = [
      "x86_64-linux"
      "aarch64-linux"
      "aarch64-darwin"
    ];
    mainProgram = "android";
  };
})
