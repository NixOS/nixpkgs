{
  lib,
  rustPlatform,
  fetchCrate,
  qt6,
  libGL,
  nix-update-script,
  versionCheckHook,
}:
rustPlatform.buildRustPackage (finalAttrs: {
  pname = "slint-viewer";
  version = "1.12.1";

  src = fetchCrate {
    inherit (finalAttrs) pname version;
    hash = "sha256-xto9oj4ObRxXT29Qi+6HMnVvu0qK+RkTgTm7xlHOk3w=";
  };

  cargoHash = "sha256-xcWVkZu4AMTnp6E3JqquDVJ+/gKr7T2Csq5KDHN64nA=";

  buildInputs = [
    qt6.qtbase
    qt6.qtsvg
    libGL
  ];

  nativeBuildInputs = [ qt6.wrapQtAppsHook ];

  # There are no tests
  doCheck = false;
  doInstallCheck = true;
  nativeInstallCheckInputs = [ versionCheckHook ];

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Viewer for .slint files from the Slint Project";
    mainProgram = "slint-viewer";
    homepage = "https://crates.io/crates/slint-viewer";
    changelog = "https://github.com/slint-ui/slint/blob/master/CHANGELOG.md";
    license = lib.licenses.gpl3Only;
    platforms = lib.platforms.linux ++ lib.platforms.darwin;
    maintainers = with lib.maintainers; [ dtomvan ];
  };
})
