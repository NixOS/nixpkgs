{
  lib,
  stdenv,
  makeDesktopItem,
  copyDesktopItems,
  fetchFromGitHub,
  qt6,
  libusb1,
}:
stdenv.mkDerivation (final: {
  pname = "openterface-qt";
  version = "0.1.0";
  src = fetchFromGitHub {
    owner = "TechxArtisanStudio";
    repo = "Openterface_QT";
    rev = "v${final.version}";
    hash = "sha256-hjiN7iA38lt7JLO+8OcO9YesX12r0SenBxjYCiObfOU=";
  };
  nativeBuildInputs = [
    copyDesktopItems
    qt6.wrapQtAppsHook
    qt6.qmake
  ];
  buildInputs = [
    libusb1
    qt6.qtbase
    qt6.qtmultimedia
    qt6.qtserialport
    qt6.qtsvg
  ];
  installPhase = ''
    runHook preInstall
    mkdir -p $out/bin
    cp ./openterfaceQT $out/bin/
    mkdir -p $out/share/pixmaps
    cp ./images/icon_256.png $out/share/pixmaps/${final.pname}.png
    runHook postInstall
  '';

  desktopItems = [
    (makeDesktopItem {
      name = "openterfaceQT";
      exec = "openterfaceQT";
      icon = final.pname;
      comment = final.meta.description;
      desktopName = "Openterface QT";
      categories = [ "Utility" ];
    })
  ];

  meta = {
    description = "Openterface mini-KVM host application for linux";
    homepage = "https://github.com/TechxArtisanStudio/Openterface_QT";
    license = lib.licenses.agpl3Only;
    mainProgram = "openterfaceQT";
    maintainers = with lib.maintainers; [ samw ];
    platforms = lib.platforms.linux;
  };
})
