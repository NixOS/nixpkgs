{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  ninja,
  pkg-config,
  qt6,
  caelestia-shell,
  nix-update-script,
  testers,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "flightdeck";
  version = "1.0.0";

  __structuredAttrs = true;
  strictDeps = true;

  src = fetchFromGitHub {
    owner = "AstraSuite";
    repo = "FlightDeck";
    tag = "v${finalAttrs.version}";
    hash = "sha256-GXRHPCxjV5vQs/ZDJQDIULQqJu0WSSOJ1Iq5VX6NB8A=";
  };

  nativeBuildInputs = [
    cmake
    ninja
    pkg-config
    qt6.wrapQtAppsHook
    qt6.qtshadertools
  ];

  buildInputs = [
    qt6.qtbase
    qt6.qtdeclarative
    qt6.qtshadertools
    qt6.qtsvg
  ];

  cmakeFlags = [
    (lib.cmakeFeature "FLIGHTDECK_VERSION" finalAttrs.version)
  ];

  preFixup = ''
    qtWrapperArgs+=(
      --prefix QML2_IMPORT_PATH : "${caelestia-shell.plugin}/${qt6.qtbase.qtQmlPrefix}:${caelestia-shell.m3shapesModule}/${qt6.qtbase.qtQmlPrefix}"
    )
  '';

  passthru = {
    updateScript = nix-update-script { };
    tests.version = testers.testVersion {
      package = finalAttrs.finalPackage;
      command = "QT_QPA_PLATFORM=offscreen flightdeck --version";
    };
  };

  meta = {
    description = "Hyprland configuration manager for Caelestia Shell";
    homepage = "https://github.com/AstraSuite/FlightDeck";
    license = lib.licenses.gpl3Only;
    maintainers = with lib.maintainers; [ rachalaraj ];
    mainProgram = "flightdeck";
    platforms = lib.platforms.linux;
  };
})
