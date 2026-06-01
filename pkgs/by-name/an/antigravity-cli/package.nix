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
      url = "https://storage.googleapis.com/antigravity-public/antigravity-cli/1.0.4-4602923213258752/linux-x64/cli_linux_x64.tar.gz";
      hash = "sha256-h2YTr+ICGH9xPAd7UMo/9htk30FwwWQtdN54LekueYM=";
    };
    "aarch64-linux" = {
      url = "https://storage.googleapis.com/antigravity-public/antigravity-cli/1.0.4-4602923213258752/linux-arm/cli_linux_arm64.tar.gz";
      hash = "sha256-zSvACSUstmLwBHEgUAw5RqOH8j/72QHMaMGL3k9Rxus=";
    };
    "aarch64-darwin" = {
      url = "https://storage.googleapis.com/antigravity-public/antigravity-cli/1.0.4-4602923213258752/darwin-arm/cli_mac_arm64.tar.gz";
      hash = "sha256-2pb4u7E3dnVUC8K58iYXYWlsIJpOLLOm9CYxp1T3Jec=";
    };
    "x86_64-darwin" = {
      url = "https://storage.googleapis.com/antigravity-public/antigravity-cli/1.0.4-4602923213258752/darwin-x64/cli_mac_x64.tar.gz";
      hash = "sha256-Jxfbb/nd/Z2OPGvyaqrBiU2IQYJ9IeIh+mKzZQWzYt0=";
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
    updateScript = [
      ./update.sh
      version
    ]
    ++ lib.concatMap (system: [
      system
      sourceData.${system}.url
    ]) (lib.attrNames sourceData);
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
