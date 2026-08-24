{
  lib,
  rustPlatform,
  fetchFromGitHub,
  versionCheckHook,
  nix-update-script,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "schemat";
  version = "0.5.4";

  src = fetchFromGitHub {
    owner = "raviqqe";
    repo = "schemat";
    tag = "v${finalAttrs.version}";
    hash = "sha256-E4cR2uZw3d2c6xoX0c1g9JlyladwEmcZDIZBg1MDQls=";
  };

  cargoHash = "sha256-7Ad14ZUVHI4E7W8Tve4Vg6LyhwD4f88wwXtSnVzbH9A=";

  doInstallCheck = true;
  nativeInstallCheckInputs = [ versionCheckHook ];

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Code formatter for Scheme, Lisp, and any S-expressions";
    homepage = "https://github.com/raviqqe/schemat";
    changelog = "https://github.com/raviqqe/schemat/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.unlicense;
    maintainers = with lib.maintainers; [ bddvlpr ];
    mainProgram = "schemat";
  };
})
