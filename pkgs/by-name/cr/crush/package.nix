{
  lib,
  buildGoModule,
  fetchFromGitHub,
  nix-update-script,
  writableTmpDirAsHomeHook,
  versionCheckHook,
}:

buildGoModule (finalAttrs: {
  pname = "crush";
  version = "0.5.0";

  src = fetchFromGitHub {
    owner = "charmbracelet";
    repo = "crush";
    tag = "v${finalAttrs.version}";
    hash = "sha256-u2w19Xmcm3cx/B8QRNGaP2qeg+Cif/L92RNlJav6H3w=";
  };

  vendorHash = "sha256-H92TgZoWdYQ863AAb2116zJtmgkKXh2hRoEBRcn5zeA=";

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
