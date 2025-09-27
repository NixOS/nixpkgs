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
  version = "0.9.2";

  src = fetchFromGitHub {
    owner = "charmbracelet";
    repo = "crush";
    tag = "v${finalAttrs.version}";
    hash = "sha256-VFAGjNtXKNjkv8Ryi28oFN/uLomXXdw6NFtyjT3pMEY=";
  };

  vendorHash = "sha256-ktF3kIr143uPwiEbgafladZRqIsmG6jI2BeumGSu82U=";

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
