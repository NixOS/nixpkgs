{
  lib,
  stdenv,
  stdenvNoCC,
  fetchurl,
  autoPatchelfHook,
  versionCheckHook,
  writableTmpDirAsHomeHook,
}:
stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "codatum-cli";
  version = "0.52.0";

  src =
    let
      platform =
        {
          aarch64-darwin = {
            name = "darwin-arm64";
            hash = "sha256-rdpHjLlc/dJ72fFeE8Gy/Y2yvJZD87nYh+nrDLPkdjw=";
          };
          aarch64-linux = {
            name = "linux-arm64";
            hash = "sha256-bkBtcnGQBoeZGgX3leZ0BBK0OM0M/DhKHECXeseZh0k=";
          };
          x86_64-linux = {
            name = "linux-x64";
            hash = "sha256-IoG8Lr53KaHYgo0EPuwEDsYjx/31QlLQtPx/VNkFwK8=";
          };
        }
        .${stdenvNoCC.hostPlatform.system};
    in
    fetchurl {
      url = "https://cli-dist.codatum.com/bin/v${finalAttrs.version}/cdm-${platform.name}.tar.gz";
      inherit (platform) hash;
    };

  sourceRoot = ".";
  __structuredAttrs = true;
  strictDeps = true;
  dontConfigure = true;
  dontBuild = true;
  # Preserve the executable's embedded payload and upstream signature.
  dontStrip = true;

  nativeBuildInputs = lib.optionals stdenvNoCC.hostPlatform.isLinux [ autoPatchelfHook ];
  buildInputs = lib.optionals stdenvNoCC.hostPlatform.isLinux [ stdenv.cc.cc.lib ];

  installPhase = ''
    runHook preInstall
    install -Dm755 cdm $out/bin/cdm
    runHook postInstall
  '';

  doInstallCheck = true;
  nativeInstallCheckInputs = [
    versionCheckHook
    writableTmpDirAsHomeHook
  ];
  versionCheckProgramArg = "--version";
  versionCheckKeepEnvironment = [ "HOME" ];

  meta = {
    description = "Command-line interface for Codatum notebooks and data analysis";
    homepage = "https://codatum.jp/cli";
    changelog = "https://cli-docs.codatum.com/cli/changelog";
    # No CLI-specific license is distributed with the upstream binary.
    license = lib.licenses.unfree;
    sourceProvenance = [ lib.sourceTypes.binaryNativeCode ];
    mainProgram = "cdm";
    maintainers = [ lib.maintainers.e-jigsaw ];
    platforms = [
      "aarch64-darwin"
      "aarch64-linux"
      "x86_64-linux"
    ];
  };
})
