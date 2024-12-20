{
  lib,
  fetchFromGitHub,
  makeDesktopItem,
  boost,
  cmake,
  libgcrypt,
  libgpg-error,
  libsodium,
  miniupnpc,
  monero-cli,
  pkg-config,
  qtbase,
  qtdeclarative,
  qtgraphicaleffects,
  qtmacextras,
  qtmultimedia,
  qtquickcontrols,
  qtquickcontrols2,
  qttools,
  qtxmlpatterns,
  quirc,
  randomx,
  rapidjson,
  stdenv,
  unbound,
  wrapQtAppsHook,
  zeromq,

  trezorSupport ? true,
  hidapi,
  libusb1,
  protobuf_21,
  python3,
  udev,
}:

stdenv.mkDerivation rec {
  pname = "monero-gui";
  version = "0.18.3.4";

  src = fetchFromGitHub {
    owner = "monero-project";
    repo = "monero-gui";
    rev = "v${version}";
    hash = "sha256-wnU24EmZig2W/psy4OhaQVy2WwR0CgljlyYwOg4bzwM=";
  };

  nativeBuildInputs = [
    cmake
    pkg-config
    wrapQtAppsHook
    (lib.getDev qttools)
  ];

  buildInputs =
    [
      boost
      libgcrypt
      libgpg-error
      libsodium
      miniupnpc
      qtbase
      qtdeclarative
      qtgraphicaleffects
      qtmultimedia
      qtquickcontrols
      qtquickcontrols2
      qtxmlpatterns
      quirc
      randomx
      rapidjson
      unbound
      zeromq
    ]
    ++ lib.optionals stdenv.hostPlatform.isDarwin [ qtmacextras ]
    ++ lib.optionals trezorSupport [
      hidapi
      libusb1
      protobuf_21
      python3
    ]
    ++ lib.optionals (trezorSupport && stdenv.hostPlatform.isLinux) [
      udev
    ];

  postUnpack = ''
    # copy monero sources here
    # (needs to be writable)
    cp -r ${monero-cli.source}/* source/monero
    chmod -R +w source/monero
  '';

  patches = [
    ./move-log-file.patch
    ./use-system-libquirc.patch
  ];

  postPatch = ''
    # set monero-gui version
    substituteInPlace src/version.js.in \
       --replace '@VERSION_TAG_GUI@' '${version}'

    # use monerod from the monero package
    substituteInPlace src/daemon/DaemonManager.cpp \
      --replace 'QApplication::applicationDirPath() + "' '"${monero-cli}/bin'

    # 1: only build external deps, *not* the full monero
    # 2: use nixpkgs libraries
    substituteInPlace CMakeLists.txt \
      --replace 'add_subdirectory(monero)' \
                'add_subdirectory(monero EXCLUDE_FROM_ALL)' \
      --replace 'add_subdirectory(external)' ""
  '';

  cmakeFlags =
    [ "-DARCH=default" ]
    ++ lib.optional trezorSupport [
      # fix build on recent gcc versions
      "-DCMAKE_CXX_FLAGS=-fpermissive"
    ];

  desktopItem = makeDesktopItem {
    name = "monero-wallet-gui";
    exec = "monero-wallet-gui";
    icon = "monero";
    desktopName = "Monero";
    genericName = "Wallet";
    categories = [
      "Network"
      "Utility"
    ];
  };

  postInstall = ''
    # install desktop entry
    install -Dm644 -t $out/share/applications \
      ${desktopItem}/share/applications/*

    # install icons
    for n in 16 24 32 48 64 96 128 256; do
      size=$n"x"$n
      install -Dm644 \
        $src/images/appicons/$size.png \
        $out/share/icons/hicolor/$size/apps/monero.png
    done;
  '';

  meta = {
    description = "Private, secure, untraceable currency";
    homepage = "https://getmonero.org/";
    license = lib.licenses.bsd3;
    platforms = lib.platforms.all;
    maintainers = with lib.maintainers; [ rnhmjoj ];
    mainProgram = "monero-wallet-gui";
  };
}
