{
  lib,
  rustPlatform,
  fetchFromGitHub,
  versionCheckHook,
  nix-update-script,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "mcat";
  version = "0.1.5";

  src = fetchFromGitHub {
    owner = "Skardyy";
    repo = "mcat";
    tag = "v${finalAttrs.version}";
    hash = "sha256-+wpcLf94FJhkufytKgVnRonivH9CVY/X0+bXx3Z8HKI=";
  };

  cargoHash = "sha256-pi/nts8YqXms5ps6bt+KQRh8twvk5qfkh5FF+/0tMOE=";

  nativeInstallCheckInputs = [
    versionCheckHook
  ];
  versionCheckProgramArg = "--version";
  doInstallCheck = true;

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Cat command for documents / images / videos and more";
    homepage = "https://github.com/Skardyy/mcat";
    changelog = "https://github.com/Skardyy/mcat/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [
      xiaoxiangmoe
    ];
    mainProgram = "mcat";
  };
})
