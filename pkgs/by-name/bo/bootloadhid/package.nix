{
  fetchurl,
  lib,
  libusb-compat-0_1,
  stdenv,
}:

stdenv.mkDerivation {
  pname = "bootloadhid";
  version = "0-unstable-2012-12-08";

  src = fetchurl {
    url = "https://www.obdev.at/downloads/vusb/bootloadHID.2012-12-08.tar.gz";
    hash = "sha256-FU5+OGKaOi7sLfZm7foe4vLppXAY8X2fD48GTMINh1Q=";
  };

  nativeBuildInputs = [
    libusb-compat-0_1
  ];

  makeFlags = [ "CC=${stdenv.cc.targetPrefix}cc" ];

  setSourceRoot = "sourceRoot=$(echo */commandline)";

  installPhase = ''
    runHook preInstall

    mkdir -p $out/bin
    install bootloadHID $out/bin

    runHook postInstall
  '';

  meta = {
    description = "USB boot loader for AVR microcontrollers with at least 2 kB of boot load section, e.g. ATMega8";
    homepage = "https://www.obdev.at/products/vusb/bootloadhid.html";
    license = lib.licenses.gpl2Plus;
    maintainers = with lib.maintainers; [ thetaoofsu ];
    mainProgram = "bootloadHID";
    platforms = lib.platforms.unix;
  };
}
