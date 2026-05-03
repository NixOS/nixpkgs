{
  lib,
  buildGoModule,
  fetchFromGitHub,
  olm,
  versionCheckHook,
}:

buildGoModule (finalAttrs: {
  pname = "picoclaw";
  version = "0.2.5";

  src = fetchFromGitHub {
    owner = "sipeed";
    repo = "picoclaw";
    tag = "v${finalAttrs.version}";
    hash = "sha256-Cn3ibZw2HscSAXYKICHTIHMiO9PIFRMphw75bH/s+qI=";
  };

  proxyVendor = true;
  vendorHash = "sha256-vECQmX9p+CsVZkZ120ShOS4itRrDL+ua7fe2eEh8nV0=";

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
