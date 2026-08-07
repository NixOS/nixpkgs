{
  lib,
  rustPlatform,
  fetchFromGitHub,
  versionCheckHook,
  nix-update-script,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "schemat";
  version = "0.5.3";

  src = fetchFromGitHub {
    owner = "raviqqe";
    repo = "schemat";
    tag = "v${finalAttrs.version}";
    hash = "sha256-vA5J76wU2FlKz1fxTgv8jVuV4RIOML+tI5Y/dXyc9f0=";
  };

  cargoHash = "sha256-LGZE3r9n+KtnCiCxc/3K981wq4fN6ZR/KD8b638DmeM=";

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
