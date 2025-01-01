{
  lib,
  stdenv,
  fetchFromGitHub,
  autoreconfHook,
  pkg-config,
  gtk3,
  librsvg,
  libusb1,
}:

stdenv.mkDerivation rec {
  pname = "inklingreader";
  version = "unstable-2017-09-07";

  src = fetchFromGitHub {
    owner = "roelj";
    repo = "inklingreader";
    rev = "90f9d0d7f5353657f4d25fd75635e29c10c08d2e";
    sha256 = "sha256-852m8g61r+NQhCYz9ghSbCG0sjao2E8B9GS06NG4GyY=";
  };

  nativeBuildInputs = [
    autoreconfHook
    pkg-config
  ];
  buildInputs = [
    gtk3
    librsvg
    libusb1
  ];

  meta = {
    homepage = "https://github.com/roelj/inklingreader";
    description = "GNU/Linux-friendly version of the Wacom Inkling SketchManager";
    license = lib.licenses.gpl3;
    maintainers = with lib.maintainers; [ totoroot ];
    platforms = lib.platforms.linux;
    mainProgram = "inklingreader";
  };
}
