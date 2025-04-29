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
  version = "1.11.0";

  src = fetchCrate {
    inherit (finalAttrs) pname version;
    hash = "sha256-Yez8GbER6ylkozQP5oQ0m0u+x/T5qQVPRt0S/NRFT60=";
  };

  useFetchCargoVendor = true;
  cargoHash = "sha256-vWTj6cJgvg10NaLw9WfHXmiG8hg7mUIH/Gj3JVvWCuA=";

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
    license = lib.licenses.gpl3Only;
    platforms = lib.platforms.linux ++ lib.platforms.darwin;
    maintainers = with lib.maintainers; [ dtomvan ];
  };
})
