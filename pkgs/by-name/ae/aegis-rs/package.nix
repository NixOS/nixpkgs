{
  lib,
  rustPlatform,
  fetchFromGitHub,
  nix-update-script,
  versionCheckHook,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "aegis-rs";
  version = "0.5.1";

  src = fetchFromGitHub {
    owner = "Granddave";
    repo = "aegis-rs";
    tag = "v${finalAttrs.version}";
    hash = "sha256-XJmStg3SoT+vYVz7twCPjVLr0ayvF08h4WJfwY1qsYk=";
  };
  cargoHash = "sha256-4Uzar6NHC4RwnHvn9c/u+uU45EzXFvMBwjP60JOwcog=";

  passthru.updateScript = nix-update-script { };

  nativeInstallCheckInputs = [ versionCheckHook ];
  doInstallCheck = true;

  meta = {
    description = "Aegis compatible OTP generator for the CLI";
    homepage = "https://github.com/Granddave/aegis-rs";
    changelog = "https://github.com/Granddave/aegis-rs/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.gpl3Plus;
    maintainers = with lib.maintainers; [ granddave ];
    mainProgram = "aegis-rs";
  };
})
