{
  lib,
  stdenv,
  fetchFromGitHub,
  fetchpatch,
  buildGoModule,
  nix-update-script,
  copyDesktopItems,
  makeDesktopItem,
  cargo,
  cmake,
  corrosion,
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
  rustPlatform,
  rustc,
}:
stdenv.mkDerivation (finalAttrs: {
  pname = "idescriptor";
  version = "0.5.0";

  src = fetchFromGitHub {
    owner = "iDescriptor";
    repo = "iDescriptor";
    tag = "v${finalAttrs.version}";
    hash = "sha256-AN3CVR9WWa9cG6C6q+hiDyTomT+RebHC1ghr6XyEtAo=";
    fetchSubmodules = true;
  };

  patches = [
    (fetchpatch {
      url = "https://github.com/iDescriptor/iDescriptor/commit/fc73e3146dc4884cf9bc1f7879574ac832cc21e6.patch";
      hash = "sha256-WqEpSY/fhbsMv0bgU2Ak5japUdohaN7zsNG1BbxJnKs=";
    })
  ];

  cargoRoot = "src/rust";

  cargoDeps = rustPlatform.fetchCargoVendor {
    inherit (finalAttrs) src cargoRoot;
    hash = "sha256-PJhMb+lMiu8ubOYVX8YVkQzeQMbBO+i6NQhvuyrCujk=";
  };

  ipatool-go-modules =
    (buildGoModule {
      pname = "ipatool-go";
      inherit (finalAttrs) version src;
      modRoot = "lib/ipatool-go";
      vendorHash = "sha256-SGdyyZU8Ze/1lJS4tKbHyfCv2yYleGcqoyA9Uzb8r/k=";
      proxyVendor = true;
      doCheck = false;
      env.GOWORK = "off";
    }).goModules;

  nativeBuildInputs = [
    cargo
    cmake
    copyDesktopItems
    pkg-config
    go
    qt6.wrapQtAppsHook
    rustPlatform.cargoSetupHook
    rustc
  ];

  buildInputs = [
    avahi-compat
    corrosion
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

  cxx-qt-cmake = fetchFromGitHub {
    owner = "kdab";
    repo = "cxx-qt-cmake";
    tag = "0.8.1";
    hash = "sha256-kXSIU71iHn+SSGikGoNeMbBpSrDJ6hwhnHslmskm8nY=";
  };

  cmakeFlags = [
    "-DPACKAGE_MANAGER_MANAGED=ON"
    "-DPACKAGE_MANAGER_HINT=nixpkgs"
    "-DFETCHCONTENT_SOURCE_DIR_CXXQT=${finalAttrs.cxx-qt-cmake}"
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

  passthru = {
    updateScript = nix-update-script { };

    goModules = finalAttrs.ipatool-go-modules;
  };

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
