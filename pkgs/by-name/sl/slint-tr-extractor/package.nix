{
  lib,
  rustPlatform,
  fetchCrate,
  nix-update-script,
  versionCheckHook,
}:
rustPlatform.buildRustPackage (finalAttrs: {
  pname = "slint-tr-extractor";
  version = "1.14.1";

  src = fetchCrate {
    inherit (finalAttrs) pname version;
    hash = "sha256-mKc75nvSeCLNZde9D2pdJk1iShdG23LRaZsB7V/S8YY=";
  };
  cargoHash = "sha256-uMYZ5kfHmiBnm9vRpoMPtsuICOi7fWervVYdVrjHgtY=";
  doInstallCheck = true;
  nativeInstallCheckInputs = [ versionCheckHook ];

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Extract translatable strings from .slint files and generate gettext-compatible translation files";
    mainProgram = "slint-tr-extractor";
    homepage = "https://crates.io/crates/slint-tr-extractor";
    changelog = "https://github.com/slint-ui/slint/blob/v${finalAttrs.version}/CHANGELOG.md";
    license = lib.licenses.gpl3Only;
    platforms = lib.platforms.linux ++ lib.platforms.darwin;
    maintainers = with lib.maintainers; [ woile ];
  };
})
