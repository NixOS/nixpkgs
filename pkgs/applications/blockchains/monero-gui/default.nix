{ stdenv, wrapQtAppsHook, makeDesktopItem
, fetchFromGitHub
, cmake, qttools, pkgconfig
, qtbase, qtdeclarative, qtgraphicaleffects
, qtmultimedia, qtxmlpatterns
, qtquickcontrols, qtquickcontrols2
, qtmacextras
, monero, miniupnpc, unbound, readline
, boost, libunwind, libsodium, pcsclite
, randomx, zeromq, libgcrypt, libgpgerror
, hidapi, rapidjson
, trezorSupport ? true
,   libusb1  ? null
,   protobuf ? null
,   python3  ? null
}:

with stdenv.lib;

assert trezorSupport -> all (x: x!=null) [ libusb1 protobuf python3 ];

let
  arch = if stdenv.isx86_64  then "x86-64"
    else if stdenv.isi686    then "i686"
    else if stdenv.isAarch64 then "armv8-a"
    else throw "unsupported architecture";
in

stdenv.mkDerivation rec {
  pname = "monero-gui";
  version = "0.17.1.7";

  src = fetchFromGitHub {
    owner  = "monero-project";
    repo   = "monero-gui";
    rev    = "v${version}";
    sha256 = "1dd2ddkxh9ynxnscysl46hj4dm063h1v13fnyah69am26qzzbby4";
  };

  nativeBuildInputs = [
    cmake pkgconfig wrapQtAppsHook
    (getDev qttools)
  ];

  buildInputs = [
    qtbase qtdeclarative qtgraphicaleffects
    qtmultimedia qtquickcontrols qtquickcontrols2
    qtxmlpatterns
    monero miniupnpc unbound readline
    randomx libgcrypt libgpgerror
    boost libunwind libsodium pcsclite
    zeromq hidapi rapidjson
  ] ++ optionals trezorSupport [ libusb1 protobuf python3 ]
    ++ optionals stdenv.isDarwin [ qtmacextras ];

  postUnpack = ''
    # copy monero sources here
    # (needs to be writable)
    cp -r ${monero.source}/* source/monero
    chmod -R +w source/monero
  '';

  patches = [ ./move-log-file.patch ];

  postPatch = ''
    # set monero-gui version
    substituteInPlace src/version.js.in \
       --replace '@VERSION_TAG_GUI@' '${version}'

    # use monerod from the monero package
    substituteInPlace src/daemon/DaemonManager.cpp \
      --replace 'QApplication::applicationDirPath() + "' '"${monero}/bin'

    # only build external deps, *not* the full monero
    substituteInPlace CMakeLists.txt \
      --replace 'add_subdirectory(monero)' \
                'add_subdirectory(monero EXCLUDE_FROM_ALL)'
  '';

  cmakeFlags = [ "-DARCH=${arch}" ];

  desktopItem = makeDesktopItem {
    name = "monero-wallet-gui";
    exec = "monero-wallet-gui";
    icon = "monero";
    desktopName = "Monero";
    genericName = "Wallet";
    categories  = "Network;Utility;";
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

  meta = {
    description  = "Private, secure, untraceable currency";
    homepage     = "https://getmonero.org/";
    license      = licenses.bsd3;
    platforms    = platforms.all;
    maintainers  = with maintainers; [ rnhmjoj ];
  };
}
