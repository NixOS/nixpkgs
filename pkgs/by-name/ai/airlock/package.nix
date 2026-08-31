{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  ninja,
  pkg-config,
  qt6,
  quickshell,
  wlr-randr,
  nix-update-script,
  testers,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "airlock";
  version = "1.3.0";

  __structuredAttrs = true;
  strictDeps = true;

  src = fetchFromGitHub {
    owner = "AstraSuite";
    repo = "Airlock";
    tag = "v${finalAttrs.version}";
    hash = "sha256-sSYL/7IBtxp6GPfqV0lDGlIz4JMD70dyA4szeJXceh0=";
  };

  nativeBuildInputs = [
    cmake
    ninja
    pkg-config
    qt6.wrapQtAppsHook
  ];

  buildInputs = [
    qt6.qtbase
    qt6.qtdeclarative
  ];

  cmakeFlags = [
    (lib.cmakeFeature "ASTRA_AIRLOCK_VERSION" finalAttrs.version)
    (lib.cmakeFeature "INSTALL_QSCONFDIR" "${placeholder "out"}/etc/xdg/quickshell/astra-airlock")
  ];

  preFixup = ''
    qtWrapperArgs+=(
      --prefix PATH : ${
        lib.makeBinPath [
          quickshell
          wlr-randr
        ]
      }
      --prefix QML2_IMPORT_PATH : "$out/lib/qt6/qml"
      --set CAELESTIA_GREETER_DIR "$out/etc/xdg/quickshell/astra-airlock"
    )
  '';

  passthru = {
    updateScript = nix-update-script { };
    tests.version = testers.testVersion {
      package = finalAttrs.finalPackage;
      command = "astra-airlock --version";
    };
  };

  meta = {
    description = "Greetd frontend for Caelestia Shell";
    homepage = "https://github.com/AstraSuite/Airlock";
    license = lib.licenses.gpl3Only;
    maintainers = with lib.maintainers; [ rachalaraj ];
    mainProgram = "astra-airlock";
    platforms = lib.platforms.linux;
  };
})
