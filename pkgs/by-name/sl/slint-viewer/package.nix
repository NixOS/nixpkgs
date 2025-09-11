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
  version = "1.13.1";

  src = fetchCrate {
    inherit (finalAttrs) pname version;
    hash = "sha256-I3iwnxft0z6kXdlHIaZUqufqJP3XrF2h+l5Y4EgLPr0=";
  };

  cargoHash = "sha256-lxxiNa1xqZDtSx19h1MxGOhK/N14fv5k+miaaNpskFc=";

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
