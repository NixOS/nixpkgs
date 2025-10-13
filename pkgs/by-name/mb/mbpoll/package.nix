{
  lib,
  stdenv,
  cmake,
  pkg-config,
  fetchFromGitHub,
  libmodbus,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "mbpoll";
  version = "1.5.2";

  src = fetchFromGitHub {
    owner = "epsilonrt";
    repo = "mbpoll";
    rev = "v${finalAttrs.version}";
    hash = "sha256-rO3j/p7MABlxcwRAZm26u7wgODGFTtetSDhPWPzTuEA=";
  };

  buildInputs = [ libmodbus ];
  nativeBuildInputs = [
    cmake
    pkg-config
  ];

  meta = with lib; {
    description = "Command line utility to communicate with ModBus slave (RTU or TCP)";
    homepage = "https://epsilonrt.fr";
    license = licenses.gpl3;
    mainProgram = "mbpoll";
    platforms = platforms.linux;
  };
})
