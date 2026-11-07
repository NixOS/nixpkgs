{
  lib,
  rustPlatform,
  fetchFromGitHub,
  versionCheckHook,
  nix-update-script,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "octomon";
  version = "0.11.7";

  src = fetchFromGitHub {
    owner = "securitypedant";
    repo = "octomon";
    tag = "v${finalAttrs.version}";
    hash = "sha256-0VEUQecd3l808NCez2fAkXAUCRkqU/EBOt00alTxh4c=";
  };

  cargoHash = "sha256-HHD2wn55TR/1nOaI64oEXnxWeZuVVnPoIvmGlON861Q=";

  strictDeps = true;
  __structuredAttrs = true;

  nativeInstallCheckInputs = [ versionCheckHook ];
  doInstallCheck = true;

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Btop-style terminal network monitor: latency, bandwidth, and Wi-Fi signal";
    homepage = "https://github.com/securitypedant/octomon";
    changelog = "https://github.com/securitypedant/octomon/releases/tag/${finalAttrs.src.tag}";
    license = with lib.licenses; [
      asl20
      mit
    ];
    maintainers = with lib.maintainers; [ tbutter ];
    mainProgram = "octomon";
  };
})
