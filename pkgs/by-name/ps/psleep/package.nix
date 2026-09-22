{
  lib,
  rustPlatform,
  fetchFromGitHub,
  versionCheckHook,
  nix-update-script,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "psleep";
  version = "0.3.0";
  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "Yesh-02";
    repo = "psleep";
    tag = "v${finalAttrs.version}";
    hash = "sha256-/Zi572GA0Stwl0JHUyFzvQ4V1GsbTetF7T74gaFoWM8=";
  };

  cargoHash = "sha256-5yzCQfuVSI02B9HQ9+HMkl7qSoMOH0so4zBPwop4KX4=";

  nativeInstallCheckInputs = [ versionCheckHook ];
  doInstallCheck = true;

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Like sleep but shows a live progress bar";
    homepage = "https://github.com/Yesh-02/psleep";
    changelog = "https://github.com/Yesh-02/psleep/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ kpbaks ];
    mainProgram = "psleep";
  };
})
