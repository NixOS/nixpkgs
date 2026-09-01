{
  lib,
  cmake,
  desktop-file-utils,
  fetchFromGitHub,
  kdePackages,
  ninja,
  pkg-config,
  python3Packages,
  qt6,
  wayland,
  wayland-scanner,
}:

python3Packages.buildPythonApplication (finalAttrs: {
  pname = "kotonoha";
  version = "0.2.1";
  pyproject = true;
  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "locez";
    repo = "kotonoha";
    tag = "v${finalAttrs.version}";
    hash = "sha256-vym24/K7K4vVFzGnNTCasLkZirsqLRuMNe+vtlDglPQ=";
  };

  build-system = [ python3Packages.scikit-build-core ];

  nativeBuildInputs = [
    cmake
    ninja
    pkg-config
    qt6.wrapQtAppsHook
    wayland-scanner
  ];

  buildInputs = [
    kdePackages.layer-shell-qt
    qt6.qtbase
    qt6.qtsvg
    qt6.qtwayland
    wayland
  ];

  dependencies = with python3Packages; [
    aiohttp
    dbus-fast
    mutagen
    pyqt6
    qasync
  ];

  # scikit-build-core owns the CMake configure/build lifecycle for the wheel.
  dontUseCmakeConfigure = true;
  cmakeFlags = [
    (lib.cmakeFeature "KOTONOHA_INSTALL_DIR" "kotonoha")
    (lib.cmakeBool "KOTONOHA_INSTALL_LICENSE" false)
  ];

  postInstall = ''
    install -Dm644 packaging/kotonoha.desktop \
      "$out/share/applications/kotonoha.desktop"
    install -Dm644 src/kotonoha/assets/icon.png \
      "$out/share/icons/hicolor/1024x1024/apps/kotonoha.png"
    install -Dm644 packaging/dev.locez.kotonoha.metainfo.xml \
      "$out/share/metainfo/dev.locez.kotonoha.metainfo.xml"
    install -Dm644 packaging/kotonoha.1 \
      "$out/share/man/man1/kotonoha.1"
  '';

  # Python's wrapper is a shell script, so wrapQtAppsHook does not detect it.
  dontWrapQtApps = true;
  postFixup = ''
    wrapQtApp "$out/bin/kotonoha"
  '';

  pythonImportsCheck = [
    "kotonoha"
    "kotonoha.platform.native"
    "PyQt6.QtCore"
    "PyQt6.QtSvg"
  ];

  nativeCheckInputs = [ desktop-file-utils ];
  doCheck = true;
  installCheckPhase = ''
    runHook preInstallCheck

    test -x "$out/bin/kotonoha"
    test -f "$out/${python3Packages.python.sitePackages}/kotonoha/libkoto-layer.so"
    desktop-file-validate "$out/share/applications/kotonoha.desktop"
    "$out/bin/kotonoha" --help > /dev/null

    runHook postInstallCheck
  '';

  meta = {
    description = "Linux desktop lyrics overlay for MPRIS players";
    homepage = "https://github.com/locez/kotonoha";
    changelog = "https://github.com/locez/kotonoha/releases/tag/v${finalAttrs.version}";
    license = with lib.licenses; [
      lgpl21Plus
      mit
    ];
    maintainers = with lib.maintainers; [ _27Aaron ];
    mainProgram = "kotonoha";
    platforms = lib.platforms.linux;
  };
})
