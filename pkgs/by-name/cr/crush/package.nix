{
  lib,
  buildGo126Module,
  fetchFromGitHub,
  nix-update-script,
  writableTmpDirAsHomeHook,
  versionCheckHook,
}:

buildGo126Module (finalAttrs: {
  pname = "crush";
  version = "0.51.2";

  src = fetchFromGitHub {
    owner = "charmbracelet";
    repo = "crush";
    tag = "v${finalAttrs.version}";
    hash = "sha256-gKn/TcrCcmRF/FajsvzSR5t6SEuuxQWhiLaSmLdR8bg=";
  };

  vendorHash = "sha256-EHESno8r2dDGcOjRHCU4799Ug7l0z8oSg/60l2HyaAg=";

  ldflags = [
    "-s"
    "-X=github.com/charmbracelet/crush/internal/version.Version=${finalAttrs.version}"
  ];

  checkFlags =
    let
      # these tests fail in the sandbox
      skippedTests = [
        "TestCoderAgent"
        "TestOpenAIClientStreamChoices"
        "TestGrepWithIgnoreFiles"
        "TestSearchImplementations"
      ];
    in
    [ "-skip=^${builtins.concatStringsSep "$|^" skippedTests}$" ];

  __darwinAllowLocalNetworking = true;

  nativeCheckInputs = [ writableTmpDirAsHomeHook ];

  nativeInstallCheckInputs = [ versionCheckHook ];
  doInstallCheck = true;

  updateScript = nix-update-script { };

  meta = {
    description = "Glamourous AI coding agent for your favourite terminal";
    homepage = "https://github.com/charmbracelet/crush";
    changelog = "https://github.com/charmbracelet/crush/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.fsl11Mit;
    maintainers = with lib.maintainers; [
      x123
      malik
      davinci42
    ];
    mainProgram = "crush";
  };
})
