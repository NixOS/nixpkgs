{
  lib,
  stdenv,
  fetchzip,
  autoPatchelfHook,
  versionCheckHook,
}:

let
  # Version and platform-specific data retrieved from Google's manifests
  version = "1.0.4";

  sourceData = {
    "x86_64-linux" = {
      url = "https://storage.googleapis.com/antigravity-public/antigravity-cli/1.0.4-6410134369468416/linux-x64/cli_linux_x64.tar.gz";
      hash = "sha256-bIfOdECzW1aumL4eAey1udyaGtb4T2120r39WNerlWY=";
    };
    "aarch64-linux" = {
      url = "https://storage.googleapis.com/antigravity-public/antigravity-cli/1.0.4-6410134369468416/linux-arm/cli_linux_arm64.tar.gz";
      hash = "sha256-yOMfJ9f9wVOLs9oNsIoeFnbHfTuKs6DZ7C2djDKY3mo=";
    };
    "aarch64-darwin" = {
      url = "https://storage.googleapis.com/antigravity-public/antigravity-cli/1.0.4-6410134369468416/darwin-arm/cli_mac_arm64.tar.gz";
      hash = "sha256-Z88fWVF5Xci3FqamkgStUT2HT+dnybAnwMLwOFpVSUE=";
    };
    "x86_64-darwin" = {
      url = "https://storage.googleapis.com/antigravity-public/antigravity-cli/1.0.4-6410134369468416/darwin-x64/cli_mac_x64.tar.gz";
      hash = "sha256-4QzK0BItTcleh8a76D4TVdkj5H2mRxKYC0oho3M363I=";
    };
  };

  sources = lib.mapAttrs (
    _system: source:
    fetchzip {
      inherit (source) url hash;
    }
  ) sourceData;

  source =
    sources.${stdenv.hostPlatform.system}
      or (throw "Unsupported system: ${stdenv.hostPlatform.system}");
in
stdenv.mkDerivation (finalAttrs: {
  pname = "antigravity-cli";
  inherit version;

  src = source;

  strictDeps = true;
  __structuredAttrs = true;

  nativeBuildInputs = lib.optionals stdenv.isLinux [ autoPatchelfHook ];

  dontBuild = true;
  dontConfigure = true;

  installPhase = ''
    runHook preInstall

    install -Dm755 antigravity $out/bin/agy

    runHook postInstall
  '';

  nativeInstallCheckInputs = [ versionCheckHook ];
  doInstallCheck = true;

  passthru = {
    inherit sources;
    updateScript = ./update.py;
  };

  meta = {
    description = "Google's Go-based terminal user interface (TUI) agent client";
    homepage = "https://antigravity.google";
    changelog = "https://antigravity.google/changelog";
    license = lib.licenses.unfree;
    maintainers = with lib.maintainers; [
      adrielvelazquez
      u3kkasha
    ];
    platforms = lib.attrNames sourceData;
    mainProgram = "agy";
    sourceProvenance = with lib.sourceTypes; [ binaryNativeCode ];
  };
})
