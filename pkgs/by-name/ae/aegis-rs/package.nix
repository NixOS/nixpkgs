{
  lib,
  rustPlatform,
  fetchFromGitHub,
  nix-update-script,
  versionCheckHook,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "aegis-rs";
  version = "0.5.0";

  src = fetchFromGitHub {
    owner = "Granddave";
    repo = "aegis-rs";
    tag = "v${finalAttrs.version}";
    hash = "sha256-V6b9CDLjpyRb/MlbAswQ2kJFGeYDu9r2Y/8lBB+kLGc=";
  };
  cargoHash = "sha256-QYTmTJiwqslFM1VT+B+HtA8idvhKOPY4+ip/FqQGZ34=";

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
