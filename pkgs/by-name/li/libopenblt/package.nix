{ lib, stdenv, fetchFromGitHub, cmake, libusb1 }:

let
  pname = "libopenblt";
  version = "1.17.00";
in
stdenv.mkDerivation {

  inherit pname version;

  src = fetchFromGitHub {
    owner = "feaser";
    repo = "openblt";
    rev = "openblt_v0${lib.replaceStrings ["."] [""] version}"; # will break at version 10.x.x
    sparseCheckout = [ "Host/Source/" ];
    hash = "sha256-eO72zVZFFQPoo75pfeqawwYKimoLqUeqnzz/E2YvSYc=";
  };

  preConfigure = ''
    export srcDirPwd=$(pwd) # to avoid using NIX_BUILD_TOP
    cd ./Host/Source/LibOpenBLT/
  '';

  installPhase = ''
    cd $srcDirPwd
    install -D "Host/libopenblt.so" "$out/lib/libopenblt.so"
    install -D "Host/Source/LibOpenBLT/openblt.h" "$out/include/openblt.h"
  '';

  buildInputs = [ libusb1 ];
  nativeBuildInputs = [ cmake ];

  meta = {
    description = "API for communicating with a microcontrollers running the OpenBLT bootloader";
    homepage = "https://www.feaser.com/openblt/doku.php?id=manual:libopenblt";
    license = lib.licenses.gpl3;
    platforms = lib.platforms.linux;
    maintainers = with lib.maintainers; [ simoneruffini ];
  };
}
