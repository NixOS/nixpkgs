{
  lib,
  buildGo125Module,
  fetchFromGitHub,
  nix-update-script,
  writableTmpDirAsHomeHook,
  versionCheckHook,
}:

buildGo125Module (finalAttrs: {
  pname = "crush";
  version = "0.7.1";

  src = fetchFromGitHub {
    owner = "charmbracelet";
    repo = "crush";
    tag = "v${finalAttrs.version}";
    hash = "sha256-3wBGN3Uit1Xw8ZQ4WyR4PhA66Cfhl6YljMEbpaaJP60=";
  };

  vendorHash = "sha256-qUcgVu6+cSFYDCsIB1pB5Vy3adWua2Rs8P9SNXJEjcA=";

  # rename TestMain to prevent it from running, as it panics in the sandbox.
  postPatch = ''
    substituteInPlace internal/llm/provider/openai_test.go \
      --replace-fail \
        "func TestMain" \
        "func DisabledTestMain"
  '';

  ldflags = [
    "-s"
    "-X=github.com/charmbracelet/crush/internal/version.Version=${finalAttrs.version}"
  ];

  checkFlags =
    let
      # these tests fail in the sandbox
      skippedTests = [
        "TestOpenAIClientStreamChoices"
        "TestGrepWithIgnoreFiles"
        "TestSearchImplementations"
      ];
    in
    [ "-skip=^${builtins.concatStringsSep "$|^" skippedTests}$" ];

  __darwinAllowLocalNetworking = true;

  nativeCheckInputs = [ writableTmpDirAsHomeHook ];

  nativeInstallCheckInputs = [ versionCheckHook ];
  versionCheckProgramArg = "--version";
  doInstallCheck = true;

  updateScript = nix-update-script { };

  meta = {
    description = "Glamourous AI coding agent for your favourite terminal";
    homepage = "https://github.com/charmbracelet/crush";
    changelog = "https://github.com/charmbracelet/crush/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.fsl11Mit;
    maintainers = with lib.maintainers; [ x123 ];
    mainProgram = "crush";
  };
})
