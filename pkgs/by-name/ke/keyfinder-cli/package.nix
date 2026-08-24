{
  lib,
  stdenv,
  fetchFromGitHub,
  ffmpeg,
  libkeyfinder,
  fftw,
  cmake,
  pkg-config,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "keyfinder-cli";
  version = "1.2.0";

  src = fetchFromGitHub {
    repo = "keyfinder-cli";
    owner = "EvanPurkhiser";
    rev = "v${finalAttrs.version}";
    hash = "sha256-WdZ5jiq5bfwiq1RK4XDRhqh2gAukq3hLCA56K/f+84g=";
  };

  nativeBuildInputs = [
    cmake
    pkg-config
  ];

  buildInputs = [
    ffmpeg
    libkeyfinder
    fftw
  ];

  meta = {
    inherit (finalAttrs.src.meta) homepage;
    description = "Musical key detection for digital audio (command-line tool)";
    longDescription = ''
      This small utility is the automation-oriented DJ's best friend. By making
      use of Ibrahim Sha'ath's high quality libKeyFinder library, it can be
      used to estimate the musical key of many different audio formats.
    '';
    license = lib.licenses.gpl3Plus;
    platforms = lib.platforms.unix;
    mainProgram = "keyfinder-cli";
  };
})
