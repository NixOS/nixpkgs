{
  lib,
  stdenv,
  makeDesktopItem,
  copyDesktopItems,
  fetchFromGitHub,
  qt6,
  libusb1,

  libva,
  nix-update-script,
  udev,
  pkg-config,
  ffmpeg,
}:
stdenv.mkDerivation (finalAttrs: {
  pname = "openterface-qt";
  version = "0.5.30";

  src = fetchFromGitHub {
    owner = "TechxArtisanStudio";
    repo = "Openterface_QT";
    tag = "${finalAttrs.version}";
    hash = "sha256-7ZgdAEQXy9QS7hRzrHOQEuimllRQ4w+u1/3DWXB3jUc=";
  };

  nativeBuildInputs = [
    pkg-config
    copyDesktopItems
    qt6.wrapQtAppsHook
    qt6.qmake
    qt6.qttools
  ];

  buildInputs = [
    libusb1
    qt6.qtbase
    qt6.qtmultimedia
    qt6.qtserialport
    qt6.qtsvg
    qt6.qthttpserver
    udev
    ffmpeg
    libva
  ];

  preBuild = ''
    lrelease openterfaceQT.pro
  '';

  installPhase = ''
    runHook preInstall

    mkdir -p $out/bin
    cp ./openterfaceQT $out/bin/
    mkdir -p $out/share/pixmaps
    cp ./images/icon_256.png $out/share/pixmaps/openterface-qt.png
    mkdir -p $out/etc/udev/rules.d

    # Install the udev rules from the packaging/archlinux until this issue is resolved:
    # https://github.com/TechxArtisanStudio/Openterface_QT/issues/606
    install -Dm644 packaging/archlinux/openterfaceqt-udev.rules $out/etc/udev/rules.d/51-openterface.rules

    runHook postInstall
  '';

  doInstallCheck = true;

  desktopItems = [
    (makeDesktopItem {
      name = "openterfaceQT";
      exec = "openterfaceQT";
      icon = finalAttrs.pname;
      comment = finalAttrs.meta.description;
      desktopName = "Openterface QT";
      categories = [ "Utility" ];
    })
  ];

  # use a github releases for autoupdate
  passthru.updateScript = nix-update-script { extraArgs = [ "--use-github-releases" ]; };

  meta = {
    description = "Openterface mini-KVM host application for linux";
    homepage = "https://github.com/TechxArtisanStudio/Openterface_QT";
    license = lib.licenses.agpl3Only;
    mainProgram = "openterfaceQT";
    maintainers = with lib.maintainers; [ samw ];
    platforms = lib.platforms.linux;
  };
})
