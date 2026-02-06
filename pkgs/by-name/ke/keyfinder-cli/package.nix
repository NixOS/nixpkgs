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
  version = "1.1.5";

  src = fetchFromGitHub {
    repo = "keyfinder-cli";
    owner = "EvanPurkhiser";
    rev = "v${finalAttrs.version}";
    hash = "sha256-xa2VqVfcK7T+InEXoKUrpkKDAo0jvVofVrgwe7SwPzE=";
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
    homepage = "https://github.com/evanpurkhiser/keyfinder-cli";
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
