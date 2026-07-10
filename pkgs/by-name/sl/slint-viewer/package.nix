{
  lib,
  rustPlatform,
  fetchCrate,

  fontconfig,
  libGL,
  pkg-config,
  qt6,

  nix-update-script,
  versionCheckHook,
}:
rustPlatform.buildRustPackage (finalAttrs: {
  pname = "slint-viewer";
  version = "1.17.0";

  src = fetchCrate {
    inherit (finalAttrs) pname version;
    hash = "sha256-2Zjt7kt9tCxDyixa7Az0cPXh3noR2BN7Nxrq2bdxkSs=";
  };

  cargoHash = "sha256-KaVPQ14QQpabaJVsyhsQ3j546j63Lp16AzQtuz49niY=";

  buildInputs = [
    qt6.qtbase
    qt6.qtsvg
    fontconfig
    libGL
  ];

  nativeBuildInputs = [
    pkg-config
    qt6.wrapQtAppsHook
  ];

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
