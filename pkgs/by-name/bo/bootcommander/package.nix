{ lib, stdenv, fetchFromGitHub, cmake, libopenblt }:

let
  pname = "bootcommander";
  version = "1.15.00";
in
stdenv.mkDerivation rec {

  inherit pname version;

  src = fetchFromGitHub {
    owner = "feaser";
    repo = "openblt";
    rev = "openblt_v${lib.replaceStrings ["."] [""] version}"; # will break at version 10.x.x
    sparseCheckout = [ "Host/Source/" ];
    hash = "sha256-eO72zVZFFQPoo75pfeqawwYKimoLqUeqnzz/E2YvSYc=";
  };

  preConfigure = ''
    export SRCDIRPWD=$(pwd) # to avoid using NIX_BUILD_TOP
    cd ./Host/Source/BootCommander/
  '';

  installPhase = ''
    cd $SRCDIRPWD
    install -D "Host/BootCommander" "$out/bin/BootCommander"
    ln -s "$out/bin/BootCommander" "$out/bin/bootcommander"
  '';

  buildInputs = [ libopenblt ];
  nativeBuildInputs = [ cmake ];

  meta = {
    description = "CLI program to performe firmware updates on microcontrollers that run the OpenBLT bootloader";
    homepage = "https://www.feaser.com/openblt/doku.php?id=manual:bootcommander";
    license = lib.licenses.gpl3;
    platforms = lib.platforms.linux;
    maintainers = with lib.maintainers; [ simoneruffini ];
  };
}
