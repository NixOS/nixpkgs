{
  lib,
  stdenv,
  fetchurl,
  autoPatchelfHook,
  writableTmpDirAsHomeHook,
  versionCheckHook,
}:

let
  platformData = {
    x86_64-linux = {
      url = "https://dl.google.com/android/cli/latest/linux_x86_64/android-cli";
      hash = "sha256-1F9RVDPqiy60zs2CfWytKSPKeRC9KDTogw4Ml59HaeY=";
    };
    x86_64-darwin = {
      url = "https://dl.google.com/android/cli/latest/darwin_x86_64/android-cli";
      hash = "sha256-bXP9rRMSqQa3+kfUJnIeDb1LZXh2P2A6ytwunzjyfGs=";
    };
    aarch64-darwin = {
      url = "https://dl.google.com/android/cli/latest/darwin_arm64/android-cli";
      hash = "sha256-r47LXmilevW0td4N+SRTR7EFnCrPBdG7G/oTUAea90Q=";
    };
  };

  systemData =
    platformData.${stdenv.hostPlatform.system}
      or (throw "Unsupported system: ${stdenv.hostPlatform.system}");

in
stdenv.mkDerivation {
  pname = "android-cli";
  version = "1.0.15433482";

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
