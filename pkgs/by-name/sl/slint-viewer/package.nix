{
  lib,
  stdenv,
  rustPlatform,
  fetchCrate,

  fontconfig,
  libGL,
  libx11,
  libxcursor,
  libxi,
  libxkbcommon,
  pkg-config,
  qt6,
  wayland,

  autoPatchelfHook,
  nix-update-script,
  versionCheckHook,
}:
rustPlatform.buildRustPackage (finalAttrs: {
  pname = "slint-viewer";
  version = "1.18.0";

  src = fetchCrate {
    inherit (finalAttrs) pname version;
    hash = "sha256-lCDhKt1lKZnzKuOuusbWYqwLBH8NJ8sF/UaDk7gjfLc=";
  };

  cargoHash = "sha256-vp8hJuskBxeyZ2vxoKe73kEI8TR13ooNwqP7gw19yo4=";

  buildInputs = [
    qt6.qtbase
    qt6.qtsvg
    fontconfig
    libGL
  ];

  buildFeatures = [ "gettext" ];

  nativeBuildInputs = [
    pkg-config
    qt6.wrapQtAppsHook
  ]
  ++ lib.optionals stdenv.hostPlatform.isLinux [ autoPatchelfHook ]
  ++ lib.optionals stdenv.hostPlatform.isDarwin [ rustPlatform.bindgenHook ];

  # stolen from the surfer package
  runtimeDependencies = lib.optionals stdenv.hostPlatform.isLinux [
    libGL
    libx11
    libxcursor
    libxi
    libxkbcommon
    wayland
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
