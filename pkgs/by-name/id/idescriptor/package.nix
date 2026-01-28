{
  lib,
  stdenv,
  fetchFromGitHub,
  buildGoModule,
  copyDesktopItems,
  makeDesktopItem,
  cmake,
  pkg-config,
  avahi-compat,
  ffmpeg,
  libheif,
  libimobiledevice,
  libimobiledevice-glue,
  libplist,
  go,
  qrencode,
  libssh,
  libtatsu,
  libusbmuxd,
  libusb1,
  libzip,
  openssl,
  pugixml,
  qt6,
  lxqt,
}:
stdenv.mkDerivation (finalAttrs: {
  pname = "idescriptor";
  version = "0.1.2";

  src = fetchFromGitHub {
    owner = "iDescriptor";
    repo = "iDescriptor";
    tag = "v${finalAttrs.version}";
    hash = "sha256-pj/8PCZUTPu28MQd3zL8ceDsQy4+55348ZOCpiQaiEo=";
    fetchSubmodules = true;
  };

  ipatool-go-modules =
    (buildGoModule {
      pname = "ipatool-go";
      inherit (finalAttrs) version src;
      modRoot = "lib/ipatool-go";
      vendorHash = "sha256-4ZCNgLAcZtEd7zDbIu3kyP/Cyp6TaBM9gyZEohgzCk8=";
      proxyVendor = true;
      doCheck = false;
      env.GOWORK = "off";
    }).goModules;

  nativeBuildInputs = [
    cmake
    copyDesktopItems
    pkg-config
    go
    qt6.wrapQtAppsHook
  ];

  buildInputs = [
    avahi-compat
    ffmpeg
    libheif
    libimobiledevice
    libimobiledevice-glue
    libplist
    qrencode
    libssh
    libtatsu
    libusbmuxd
    libusb1
    libzip
    openssl
    pugixml
    qt6.qtbase
    qt6.qtlocation
    qt6.qtmultimedia
    qt6.qtpositioning
    qt6.qtserialport
    qt6.qtsvg
    qt6.qttools
    qt6.qtwayland
    lxqt.qtermwidget
  ];

  cmakeFlags = [
    "-DPACKAGE_MANAGER_MANAGED=ON"
    "-DPACKAGE_MANAGER_HINT=nixpkgs"
  ];

  preConfigure = ''
    export GOCACHE=$TMPDIR/go-cache
    export GOPATH=$TMPDIR/go
    export GOPROXY=file://${finalAttrs.ipatool-go-modules}
    export GOSUMDB=off
  '';

  postInstall = ''
    install -Dm644 -t $out/lib/udev/rules.d ${./99-idevice.rules}

    install -Dm644 $src/resources/icons/app-icon/icon.png \
      $out/share/icons/hicolor/256x256/apps/idescriptor.png
  '';

  desktopItems = [
    (makeDesktopItem {
      name = "iDescriptor";
      exec = "iDescriptor";
      icon = "idescriptor";
      desktopName = "iDescriptor";
      comment = "Cross-platform iDevice management tool";
      categories = [
        "System"
        "Utility"
      ];
    })
  ];

  meta = {
    homepage = "https://github.com/iDescriptor/iDescriptor";
    changelog = "https://github.com/iDescriptor/iDescriptor/releases/tag/v${finalAttrs.version}";
    description = "A cross-platform iDevice management tool";
    license = lib.licenses.agpl3Only;
    platforms = lib.platforms.linux;
    maintainers = with lib.maintainers; [ amadejkastelic ];
    mainProgram = "iDescriptor";
  };
})
