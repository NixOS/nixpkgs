{
  lib,
  rustPlatform,
  fetchCrate,
  nix-update-script,
  versionCheckHook,
}:
rustPlatform.buildRustPackage (finalAttrs: {
  pname = "slint-tr-extractor";
  version = "1.16.1";

  src = fetchCrate {
    inherit (finalAttrs) pname version;
    hash = "sha256-y3hsZ4a3tf2CDa6pkO928xZxeWAwsxK+H2LTa7MhcFs=";
  };
  cargoHash = "sha256-qmLELQ/PNMUW+XMsJGPK2CnqnLAhc3W4KqtizdxFGMM=";
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
