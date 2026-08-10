{
  lib,
  rustPlatform,
  fetchCrate,
  nix-update-script,
  versionCheckHook,
}:
rustPlatform.buildRustPackage (finalAttrs: {
  pname = "slint-tr-extractor";
  version = "1.17.1";

  src = fetchCrate {
    inherit (finalAttrs) pname version;
    hash = "sha256-ytJLH7CcfLjpzRXljTUZS1rzueBljGXwpDOpKKdBJ+k=";
  };
  cargoHash = "sha256-D+wHG+e2gVt7I7h0KobY4bLkphZJXWaTCoSp2gpNctE=";
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
