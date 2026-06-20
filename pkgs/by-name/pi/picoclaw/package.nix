{
  lib,
  buildGoModule,
  fetchFromGitHub,
  olm,
  versionCheckHook,
}:

buildGoModule (finalAttrs: {
  pname = "picoclaw";
  version = "0.2.9";

  src = fetchFromGitHub {
    owner = "sipeed";
    repo = "picoclaw";
    tag = "v${finalAttrs.version}";
    hash = "sha256-oMees7EKANS5dkMHIqAHfGcumrNMtTEEA+dmpl8/dLE=";
  };

  proxyVendor = true;
  vendorHash = "sha256-LjTLLeK2M8W34z1M11wKuBAoDI6ciCG3f4FRWAre/sY=";

  buildInputs = [ olm ];

  preBuild = ''
    go generate ./...
  '';

  ldflags = [
    "-s"
    "-w"
    "-X github.com/sipeed/picoclaw/pkg/config.Version=${finalAttrs.version}"
  ];

  doInstallCheck = true;
  nativeInstallCheckInputs = [ versionCheckHook ];
  versionCheckProgramArg = "version";

  checkFlags =
    let
      skippedTests = [
        "TestGetVersion"
        "TestCodexCliProvider_MockCLI_Success"
        "TestCodexCliProvider_MockCLI_Error"
        "TestCodexCliProvider_MockCLI_WithModel"
        "TestGatewayStopRefusesNonGatewayAttachedProcess"
        "TestGatewayStatusIgnoresAndRemovesPidFileForNonGatewayProcess"
      ];
    in
    [ "-skip=^${builtins.concatStringsSep "$|^" skippedTests}$" ];

  meta = {
    description = "Tiny, Fast, and Deployable anywhere - automate the mundane, unleash your creativity";
    homepage = "https://github.com/sipeed/picoclaw";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [
      manfredmacx
      drupol
    ];
    mainProgram = "picoclaw";
  };
})
