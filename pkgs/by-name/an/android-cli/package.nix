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
  version = "1.1.16717390";
  platformData = {
    x86_64-linux = fetchurl {
      url = "https://dl.google.com/android/cli/${version}/linux_x86_64/android-cli";
      hash = "sha256-s07Quu7/oqruJyDYJJG5dYNWluLlaEBEkHi+yIVDZWQ=";
    };
    aarch64-linux = fetchurl {
      url = "https://dl.google.com/android/cli/${version}/linux_arm64/android-cli";
      hash = "sha256-QvH7k3OjmM5ytl+h1z3ctrekGavfRc8KKTtRvqEojqU=";
    };
    aarch64-darwin = fetchurl {
      url = "https://dl.google.com/android/cli/${version}/darwin_arm64/android-cli";
      hash = "sha256-6cbhn17YFC4ol+C2i0duF2hjPldAqlS/wjR2fMJkAf4=";
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
