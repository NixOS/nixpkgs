{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  ninja,
  pkg-config,
  qt6,
  quickshell,
  cliphist,
  wl-clipboard,
  nix-update-script,
  testers,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "stowaway";
  version = "1.0.0";

  __structuredAttrs = true;
  strictDeps = true;

  src = fetchFromGitHub {
    owner = "AstraSuite";
    repo = "Stowaway";
    tag = "v${finalAttrs.version}";
    hash = "sha256-90KdJImynRk4gSLPsmasNvxryN0XFPh8eApsYl7YSiM=";
  };

  postPatch = ''
    substituteInPlace launcher/main.cpp \
      --replace-fail '/etc/xdg/quickshell/astra-stowaway/shell.qml' "$out/etc/xdg/quickshell/astra-stowaway/shell.qml" \
      --replace-fail '"/usr/lib/qt6/qml"' "\"$out/lib/qt6/qml\"" \
      --replace-fail '"/usr/lib/qt6/qml/Astra/Stowaway"' "\"$out/lib/qt6/qml/Astra/Stowaway\""
  '';

  nativeBuildInputs = [
    cmake
    ninja
    pkg-config
    qt6.wrapQtAppsHook
  ];

  buildInputs = [
    qt6.qtbase
    qt6.qtdeclarative
    qt6.qtsvg
  ];

  cmakeFlags = [
    (lib.cmakeFeature "STOWAWAY_VERSION" finalAttrs.version)
    (lib.cmakeFeature "INSTALL_QSCONFDIR" "${placeholder "out"}/etc/xdg/quickshell/astra-stowaway")
  ];

  preFixup = ''
    qtWrapperArgs+=(
      --prefix PATH : ${
        lib.makeBinPath [
          quickshell
          cliphist
          wl-clipboard
        ]
      }
      --prefix QML2_IMPORT_PATH : "$out/lib/qt6/qml"
    )
  '';

  passthru = {
    updateScript = nix-update-script { };
    tests.version = testers.testVersion {
      package = finalAttrs.finalPackage;
      command = "stowaway --version";
    };
  };

  meta = {
    description = "Modern Wayland clipboard manager and emoji picker overlay";
    homepage = "https://github.com/AstraSuite/Stowaway";
    license = lib.licenses.gpl3Only;
    maintainers = with lib.maintainers; [ rachalaraj ];
    mainProgram = "stowaway";
    platforms = lib.platforms.linux;
  };
})
