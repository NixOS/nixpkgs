{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  libusb1,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "libopenblt";
  version = "1.17.00";

  src = fetchFromGitHub {
    owner = "feaser";
    repo = "openblt";
    rev = "refs/tags/openblt_v0${lib.replaceStrings [ "." ] [ "" ] finalAttrs.version}"; # will break at version 10.x.x
    sparseCheckout = [ "Host/Source/" ];
    hash = "sha256-eO72zVZFFQPoo75pfeqawwYKimoLqUeqnzz/E2YvSYc=";
  };

  preConfigure = ''
    export srcDirPwd=$(pwd) # to avoid using NIX_BUILD_TOP
    cd ./Host/Source/LibOpenBLT/
  '';

  installPhase = ''
    cd $srcDirPwd
    runHook preInstall
    install -D "Host/libopenblt.so" "$out/lib/libopenblt.so"
    install -D "Host/Source/LibOpenBLT/openblt.h" "$out/include/openblt.h"
    runHook postInstall
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
})
