{ lib, stdenv, wrapQtAppsHook, makeDesktopItem
, fetchFromGitHub
, cmake, qttools, pkg-config
, qtbase, qtdeclarative, qtgraphicaleffects
, qtmultimedia, qtxmlpatterns
, qtquickcontrols, qtquickcontrols2
, qtmacextras
, monero-cli, miniupnpc, unbound, readline
, boost, libunwind, libsodium, pcsclite
, randomx, zeromq, libgcrypt, libgpg-error
, hidapi, rapidjson, quirc
, trezorSupport ? true, libusb1, protobuf, python3
}:

stdenv.mkDerivation rec {
  pname = "monero-gui";
  version = "0.18.2.2";

  src = fetchFromGitHub {
    owner = "monero-project";
    repo = "monero-gui";
    rev = "v${version}";
    sha256 = "c5+bgu+hF3mOwF3ZxksPMiYUFyDRMFLA3f5FWeLsSBU=";
  };

  nativeBuildInputs = [
    cmake pkg-config wrapQtAppsHook
    (lib.getDev qttools)
  ];

  buildInputs = [
    qtbase qtdeclarative qtgraphicaleffects
    qtmultimedia qtquickcontrols qtquickcontrols2
    qtxmlpatterns
    monero-cli miniupnpc unbound readline
    randomx libgcrypt libgpg-error
    boost libunwind libsodium pcsclite
    zeromq hidapi rapidjson quirc
  ] ++ lib.optionals trezorSupport [ libusb1 protobuf python3 ]
    ++ lib.optionals stdenv.isDarwin [ qtmacextras ];

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

  cmakeFlags = [ "-DARCH=default" ];

  desktopItem = makeDesktopItem {
    name = "monero-wallet-gui";
    exec = "monero-wallet-gui";
    icon = "monero";
    desktopName = "Monero";
    genericName = "Wallet";
    categories  = [ "Network" "Utility" ];
  };

  postInstall = ''
    # install desktop entry
    install -Dm644 -t $out/share/applications \
      ${desktopItem}/share/applications/*

    # install icons
    for n in 16 24 32 48 64 96 128 256; do
      size=$n"x"$n
      install -Dm644 \
        -t $out/share/icons/hicolor/$size/apps/monero.png \
        $src/images/appicons/$size.png
    done;
  '';

  meta = with lib; {
    description  = "Private, secure, untraceable currency";
    homepage     = "https://getmonero.org/";
    license      = licenses.bsd3;
    platforms    = platforms.all;
    maintainers  = with maintainers; [ rnhmjoj ];
  };
}
