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
  version = "1.13.0";

  src = fetchCrate {
    inherit (finalAttrs) pname version;
    hash = "sha256-KasOZia9bIgMi+haXYMbu+fRrM5ZLtaC4rwHZEQOtcY=";
  };

  cargoHash = "sha256-0NuwxRR2BrA9j0uKYfDVFyDZEtx1byRVnLB3TZbAAP0=";

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
