{
  lib,
  buildGoModule,
  fetchFromGitHub,
  versionCheckHook,
}:

buildGoModule (finalAttrs: {
  pname = "picoclaw";
  version = "0.2.0";

  src = fetchFromGitHub {
    owner = "sipeed";
    repo = "picoclaw";
    tag = "v${finalAttrs.version}";
    hash = "sha256-zCeURNN152yL3Qi1UFDvSB85xflbLAMzQUTwGThALss=";
  };

  proxyVendor = true;
  vendorHash = "sha256-CsTGC5Ajo9RV6rJPQgnFqA+bQ2TEafI4tt3iXpVwaeY=";

  preBuild = ''
    go generate ./...
  '';

  ldflags = [
    "-s"
    "-w"
    "-X github.com/sipeed/picoclaw/cmd/picoclaw/internal.version=${finalAttrs.version}"
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
    description = "Tiny, Fast, and Deployable anywhere — automate the mundane, unleash your creativity";
    homepage = "https://github.com/sipeed/picoclaw";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ drupol ];
    mainProgram = "picoclaw";
  };
})
