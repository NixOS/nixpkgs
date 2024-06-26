{
  lib,
  stdenv,
  fetchFromGitHub,
  ffmpeg,
  libkeyfinder,
}:

stdenv.mkDerivation rec {
  pname = "keyfinder-cli";
  version = "1.1.1";

  src = fetchFromGitHub {
    repo = "keyfinder-cli";
    owner = "EvanPurkhiser";
    rev = "v${version}";
    sha256 = "1mlcygbj3gqii3cz8jd6ks1lz612i4jp0343qjg293xm39fg47ns";
  };

  buildInputs = [
    ffmpeg
    libkeyfinder
  ];

  makeFlags = [ "PREFIX=$(out)" ];

  enableParallelBuilding = true;

  meta = with lib; {
    inherit (src.meta) homepage;
    description = "Musical key detection for digital audio (command-line tool)";
    longDescription = ''
      This small utility is the automation-oriented DJ's best friend. By making
      use of Ibrahim Sha'ath's high quality libKeyFinder library, it can be
      used to estimate the musical key of many different audio formats.
    '';
    license = licenses.gpl3Plus;
    platforms = platforms.unix;
    mainProgram = "keyfinder-cli";
  };
}
