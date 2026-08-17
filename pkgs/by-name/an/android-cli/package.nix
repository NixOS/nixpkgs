{
  lib,
  stdenv,
  fetchurl,
  autoPatchelfHook,
  writableTmpDirAsHomeHook,
  versionCheckHook,
}:

let
  version = "1.0.15498356";
  platformData = {
    x86_64-linux = {
      url = "https://dl.google.com/android/cli/${version}/linux_x86_64/android-cli";
      hash = "sha256-TmwLwLKqnMCxWwtX8m50KflmisfeG3PjZsBs7z9vccU=";
    };
    x86_64-darwin = {
      url = "https://dl.google.com/android/cli/${version}/darwin_x86_64/android-cli";
      hash = "sha256-ThBobULyevoKlp/22tdUqnBBccX6FbPDNrSwwuK4wnw=";
    };
    aarch64-darwin = {
      url = "https://dl.google.com/android/cli/${version}/darwin_arm64/android-cli";
      hash = "sha256-E3PC0Ivf6MoYRQu56dSD/49LI8DJZhXL27/o6daH0Sg=";
    };
  };

  systemData =
    platformData.${stdenv.hostPlatform.system}
      or (throw "Unsupported system: ${stdenv.hostPlatform.system}");

in
stdenv.mkDerivation {
  pname = "android-cli";
  inherit version;

  strictDeps = true;
  __structuredAttrs = true;

  src = fetchurl {
    name = "android-cli";
    url = systemData.url;
    hash = systemData.hash;
  };

  dontUnpack = true;

  nativeBuildInputs = lib.optionals stdenv.hostPlatform.isLinux [
    autoPatchelfHook
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

  meta = with lib; {
    description = "Android Command-Line Tool (CLI) by Google";
    homepage = "https://developer.android.com/tools/agents/android-cli";
    license = licenses.unfree;
    sourceProvenance = with sourceTypes; [ binaryNativeCode ];
    maintainers = with maintainers; [ kirillrdy ];
    teams = with teams; [ android ];
    platforms = [
      "x86_64-linux"
      "x86_64-darwin"
      "aarch64-darwin"
    ];
    mainProgram = "android";
  };
}
