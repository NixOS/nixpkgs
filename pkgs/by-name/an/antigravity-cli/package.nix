{
  lib,
  stdenv,
  fetchzip,
  autoPatchelfHook,
  versionCheckHook,
}:

let
  # Version and platform-specific data retrieved from Google's manifests
  version = "1.0.2";

  sources = {
    "x86_64-linux" = {
      url = "https://storage.googleapis.com/antigravity-public/antigravity-cli/1.0.2-6109799369277440/linux-x64/cli_linux_x64.tar.gz";
      hash = "sha256-XAq2oHWaAe2AoAgDBb1/NvABfkodg3xYTDmTY5H9RD0=";
    };
    "aarch64-linux" = {
      url = "https://storage.googleapis.com/antigravity-public/antigravity-cli/1.0.2-6109799369277440/linux-arm/cli_linux_arm64.tar.gz";
      hash = "sha256-7pj7TMHg+Z7DyWVmXOMqoM9kQkw5FxXTF+P4hGYc2hE=";
    };
    "aarch64-darwin" = {
      url = "https://storage.googleapis.com/antigravity-public/antigravity-cli/1.0.2-6109799369277440/darwin-arm/cli_mac_arm64.tar.gz";
      hash = "sha256-stu8KZDa5id5wVImTgyedkIKJPdkBTagRCphoYLWUoI=";
    };
    "x86_64-darwin" = {
      url = "https://storage.googleapis.com/antigravity-public/antigravity-cli/1.0.2-6109799369277440/darwin-x64/cli_mac_x64.tar.gz";
      hash = "sha256-KDOEEgFhvpO9bifljSuhRKpb+J6c+q4TWmnrNAAS3A0=";
    };
  };

  source =
    sources.${stdenv.hostPlatform.system}
      or (throw "Unsupported system: ${stdenv.hostPlatform.system}");
in
stdenv.mkDerivation (finalAttrs: {
  pname = "antigravity-cli";
  inherit version;

  src = fetchzip {
    inherit (source) url hash;
  };

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
    updateScript = ./update.py;
  };

  meta = {
    description = "Google's Go-based terminal user interface (TUI) agent client";
    homepage = "https://antigravity.google";
    license = lib.licenses.unfree;
    maintainers = with lib.maintainers; [ u3kkasha ];
    platforms = lib.attrNames sources;
    mainProgram = "agy";
    sourceProvenance = with lib.sourceTypes; [ binaryNativeCode ];
  };
})
