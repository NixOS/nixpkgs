{
  lib,
  rustPlatform,
  fetchFromGitHub,
  versionCheckHook,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "repro-env";
  version = "0.4.3";

  src = fetchFromGitHub {
    owner = "kpcyrd";
    repo = "repro-env";
    tag = "v${finalAttrs.version}";
    hash = "sha256-ViOUS7prwLl2C2BOlwqshFks+q+xeiAD4ONdKUcDgWU=";
  };

  cargoHash = "sha256-0ljIt84CqcdC01YXU6J7RlvkN/nlU6Thige8TricFus=";

  doInstallCheck = true;
  nativeInstallCheckInputs = [ versionCheckHook ];
  versionCheckProgramArg = "--version";

  meta = {
    changelog = "https://github.com/kpcyrd/repro-env/releases/tag/v${finalAttrs.version}";
    description = "Dependency lockfiles for reproducible build environments";
    homepage = "https://github.com/kpcyrd/repro-env";
    license = with lib.licenses; [
      asl20
      mit
    ];
    maintainers = with lib.maintainers; [ ];
    mainProgram = "repro-env";
  };
})
