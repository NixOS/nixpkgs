{
  lib,
  rustPlatform,
  fetchCrate,
  nix-update-script,
  versionCheckHook,
}:
rustPlatform.buildRustPackage (finalAttrs: {
  pname = "slint-tr-extractor";
  version = "1.15.0";

  src = fetchCrate {
    inherit (finalAttrs) pname version;
    hash = "sha256-lxXJc1jDwqZTiA9wZ9i9nGwxRGvZ87s5jlHPJBdHle8=";
  };
  cargoHash = "sha256-MY9qX8FnenCahBQgMLn7dcefqao2jDixScFXzf72NAk=";
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
