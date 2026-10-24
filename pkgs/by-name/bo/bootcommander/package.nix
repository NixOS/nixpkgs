{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  libopenblt,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "bootcommander";
  version = "1.15.00";

  src = fetchFromGitHub {
    owner = "feaser";
    repo = "openblt";
    rev = "refs/tags/openblt_v0${lib.replaceStrings [ "." ] [ "" ] finalAttrs.version}"; # will break at version 10.x.x
    sparseCheckout = [ "Host/Source/" ];
    hash = "sha256-eO72zVZFFQPoo75pfeqawwYKimoLqUeqnzz/E2YvSYc=";
  };

  preConfigure = ''
    export SRCDIRPWD=$(pwd) # to avoid using NIX_BUILD_TOP
    cd ./Host/Source/BootCommander/
  '';

  installPhase = ''
    cd $SRCDIRPWD
    runHook preInstall
    install -D "Host/BootCommander" "$out/bin/BootCommander"
    ln -s "$out/bin/BootCommander" "$out/bin/bootcommander"
    runHook postInstall
  '';

  buildInputs = [ libopenblt ];
  nativeBuildInputs = [ cmake ];

  meta = {
    description = "CLI program to perform firmware updates on microcontrollers that run the OpenBLT bootloader";
    homepage = "https://www.feaser.com/openblt/doku.php?id=manual:bootcommander";
    mainProgram = "BootCommander";
    license = lib.licenses.gpl3;
    platforms = lib.platforms.linux;
    maintainers = with lib.maintainers; [ simoneruffini ];
  };
})
