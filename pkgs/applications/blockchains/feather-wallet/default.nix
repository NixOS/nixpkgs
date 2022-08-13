{ lib, stdenv, wrapQtAppsHook, makeDesktopItem
, fetchFromGitHub, fetchgit
, git, cmake, qttools, pkg-config
, qtbase, qtwebsockets, qtsvg
, miniupnpc, unbound, readline
, boost, libunwind, libsodium, pcsclite
, randomx, zeromq, libgcrypt, libgpg-error
, hidapi, rapidjson, qrencode, zbar, expat
, libzip, libusb1, protobuf, python3
}:

stdenv.mkDerivation rec {
  pname = "feather-wallet";
  version = "2.1.0";

  src = fetchgit {
    url = "https://github.com/feather-wallet/feather.git";
    rev = version;
    sha256 = "gPNDd4hRwRCAQcvF3B+LG3tYFBkvFl5uIuF50CLcPm8=";
    fetchSubmodules = true;
    leaveDotGit = true;
  };

  nativeBuildInputs = [
    cmake pkg-config wrapQtAppsHook
    (lib.getDev qttools)
  ];

  buildInputs = [
    qtbase qtwebsockets qtsvg
    miniupnpc unbound readline
    randomx libgcrypt libgpg-error
    boost libunwind libsodium pcsclite
    zeromq hidapi rapidjson qrencode zbar expat
    libusb1 protobuf libzip git
  ];

  patches = [
    ./config_fix.patch
    ./install_fix.patch
  ];

  desktopItem = makeDesktopItem {
    name = "feather-wallet";
    exec = "feather";
    icon = "feather-wallet";
    desktopName = "Feather";
    genericName = "Wallet";
    categories  = [ "Utility" ];
  };

  postInstall = ''
    # install desktop entry
    install -Dm644 -t $out/share/applications \
      ${desktopItem}/share/applications/*

    # install icons
    for n in 32 48 64 96 128 256; do
      size=$n"x"$n
      install -Dm644 \
        -t $out/share/icons/hicolor/$size/apps/feather-wallet.png \
        $src/src/assets/images/appicons/$size.png
    done;
  '';

  cmakeFlags = [
    "-DCMAKE_BUILD_TYPE=Release"
  ] ++ (if stdenv.hostPlatform.system == "x86_64-linux" then [
    "-DARCH=x86-64"
    "-DBUILD_TAG=\"linux-x64\""
  ] else if stdenv.hostPlatform.system == "aarch64-linux" then [
    "-DARCH=armv8-a"
    "-DBUILD_TAG=\"linux-armv8\""
  ] else throw "Architecture not supported");

  meta = with lib; {
    description  = "A free Monero desktop wallet";
    homepage     = "https://featherwallet.org/";
    license      = licenses.bsd3;
    platforms = [ "x86_64-linux" "aarch64-linux" ];
    maintainers  = with maintainers; [ neverupdate ];
  };
}

