{
  lib,
  stdenv,
  fetchFromGitHub,
  git,
  udev,
  qt6,
  libusb1,
  copyDesktopItems,
  makeDesktopItem,
}:

stdenv.mkDerivation {
  pname = "librevna";
  version = "1.6.5";

  strictDeps = true;
  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "jankae";
    repo = "LibreVNA";
    rev = "5fee370d4e56c30efaa0c6040a504bd01a63cc90";
    hash = "sha256-uPVnjhbFXP1Z+pJuWDX4xqQGcmbJI8ElHq8fVXN0Qcc=";
  };

  nativeBuildInputs = [
    git
    qt6.qmake
    qt6.wrapQtAppsHook
    qt6.qtsvg
    copyDesktopItems
  ];

  buildInputs = [
    udev
    qt6.qtbase
    libusb1
  ];

  preConfigure = ''
    cd Software/PC_Application/LibreVNA-GUI
  '';

  installPhase = ''
    runHook preInstall

    install -Dm755 LibreVNA-GUI $out/bin/LibreVNA-GUI
    install -Dm644 ../51-vna.rules $out/lib/udev/rules.d/51-vna.rules
    install -Dm644 resources/librevna.svg $out/share/icons/hicolor/scalable/apps/librevna.svg

    runHook postInstall
  '';

  desktopItems = [
    (makeDesktopItem {
      name = "librevna";
      desktopName = "LibreVNA GUI";
      comment = "Vector Network Analyzer for LibreVNA board";
      exec = "LibreVNA-GUI";
      icon = "librevna";
      terminal = false;
      categories = [
        "Science"
        "Engineering"
        "Electronics"
      ];
    })
  ];

  meta = {
    description = "GUI application for the LibreVNA vector network analyzer";
    homepage = "https://github.com/jankae/LibreVNA";
    maintainers = [ ];
    license = lib.licenses.gpl3Only;
    platforms = lib.platforms.linux;
  };
}
