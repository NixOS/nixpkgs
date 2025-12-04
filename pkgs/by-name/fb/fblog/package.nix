{
  lib,
  rustPlatform,
  fetchFromGitHub,
  versionCheckHook,
  nix-update-script,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "fblog";
  version = "4.16.0";

  src = fetchFromGitHub {
    owner = "brocode";
    repo = "fblog";
    rev = "v${finalAttrs.version}";
    hash = "sha256-SWwk7qNe2R1aBYGBFqltUZjeOvr4jG1P7/CPIAfHCc8=";
  };

  cargoHash = "sha256-du9FXuUNqQm1AMqcCFqeso5OPrPCxzTVl5e7kR0rpwc=";

  doInstallCheck = true;
  nativeInstallCheckInputs = [ versionCheckHook ];
  versionCheckProgramArg = "--version";

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Small command-line JSON log viewer";
    mainProgram = "fblog";
    homepage = "https://github.com/brocode/fblog";
    changelog = "https://github.com/brocode/fblog/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.wtfpl;
    maintainers = [ lib.maintainers.progrm_jarvis ];
  };
})
