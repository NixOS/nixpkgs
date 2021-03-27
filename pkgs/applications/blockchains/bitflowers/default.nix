{ lib, stdenv
, fetchFromGitHub
, cmake
, pkg-config
, bitcoin
, libtool
, libglvnd
, miniupnpc
, db
, qt4
, gl117
, zmqpp
, qtbase
, qtmultimedia
, qmake
, qtcreator
, qttools
, boost
, libdbusmenu
, qrencode
, protobuf
, protobufc
, wrapQtAppsHook }:

stdenv.mkDerivation rec {
  pname = "bitflowers";
  version = "2.0";

  src = fetchFromGitHub {
    owner = "Crypto-city";
    repo = "bitFlowers";
    rev = "v${version}";
    sha256 = "nL8fxb1auboXVQdpy4lkZ09GiORmj56FqzGpr6VK9jI=";
  };

  qmakeFlags = [ "bitFlowers-qt.pro" ];

  nativeBuildInputs = [
    qmake
    qt4
    qtbase
    bitcoin
    gl117
    libdbusmenu
    qtmultimedia
    db
    qrencode
    qtcreator
    qttools
    wrapQtAppsHook
    libtool
    libglvnd
    zmqpp
    protobuf
    miniupnpc
    protobufc
  ];

  buildInputs = [
    wrapQtAppsHook
    qt4
    qttools
    libdbusmenu
    qrencode
    qtbase
    bitcoin
    qtmultimedia

    zmqpp
    protobuf
    protobufc
    db
    libtool
    boost
    miniupnpc
    gl117
    libglvnd
  ];
  meta = with lib; {
    homepage = "https://bit-flowers.com/";
    longDescription = ''
      bitFlowers; a Crypto-city crypto currency project, which aims to provide eGifting 
      functionality directly in the core of the bitFlowers wallet. 
    '';
    license = licenses.mit;
    maintainers = with maintainers; [ ethancedwards8 ];
  };
}
