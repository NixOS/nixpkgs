{ lib, stdenv, cmake, ccache
, fetchFromGitHub
, qtbase, qtsvg
, qtwebsockets
, wrapQtAppsHook
, qrencode, zbar
, unbound, boost
, libzip, hidapi
, protobuf, makeDesktopItem
, tor, libgcrypt
, libsodium, expat
, openssl, pkg-config
, zlib, git, monero-cli
}:


stdenv.mkDerivation rec {
  pname = "feather";
  version = "2.1.0";

  src = fetchFromGitHub {
    owner = "feather-wallet";
    repo = "feather";
    rev = version;
    sha256 = "sha256-0cVuOYinhHKfeiQcZX3vvSsd+jTbTxFRh0qHhxXF76Y=";
    fetchSubmodules = true;
  };


  nativeBuildInputs = [
    cmake ccache
    wrapQtAppsHook
    pkg-config
  ];

  buildInputs = [
    qtbase qtsvg qtwebsockets
    qrencode unbound
    libzip hidapi boost
    protobuf libgcrypt tor
    openssl libsodium expat
    libgcrypt zbar zlib
  ];


  polyseed = fetchFromGitHub {
    owner = "tevador";
    repo = "polyseed";
    rev = "e38516561c647522e2e2608f13eabdeab61d9a5d";
    sha256 = "sha256-Eg9Nj95OYXQ9tSPTtk4xiefZDfp+zF6G/RWGxR16owA=";
  };

  singleapplication = fetchFromGitHub {
    owner = "itay-grudev";
    repo = "SingleApplication";
    rev = "3e8e85d1a487e433751711a8a090659684d42e3b";
    sha256 = "sha256-4UeJgSzXChzRi9azjG9k6pYRLok5Fan9b84BCCesLBs=";
  };

  postUnpack = ''
    cp -r ${monero-cli.source}/* source/monero
    cp -r ${polyseed}/* source/src/third-party/polyseed
    cp -r ${singleapplication}/* source/src/third-party/singleapplication
    chmod -R +w source/monero
    chmod -R +w source/src/third-party
  '';

  cmakeFlags = [
    "-DTOR_DIR=${tor}/bin"
    "-DTOR_VERSION=${tor.version}"
  ];

  desktopItem = makeDesktopItem rec {
    name = "feather";
    exec = name;
    icon = name;
    desktopName = "Feather";
    genericName = "Wallet";
    categories  = [ "Network" "Utility" ];
  };

  postInstall = ''
    # install desktop entry
    install -Dm644 -t $out/share/applications \
      ${desktopItem}/share/applications/*
    # install icons
    install -Dm644 $src/src/assets/images/feather.png \
      $out/share/pixmaps/feather.png
  '';

  meta = with lib; {
    description  = "A free Monero desktop wallet";
    homepage     = "https://featherwallet.org";
    license      = licenses.bsd3;
    platforms    = [ "x86_64-linux" ];
    maintainers  = with maintainers; [ gp2112 ];
  };

}
