{ lib, stdenv, fetchFromGitHub, ffmpeg_7, libkeyfinder, fftw }:

stdenv.mkDerivation rec {
  pname = "keyfinder-cli";
  version = "1.1.2";

  src = fetchFromGitHub {
    repo = "keyfinder-cli";
    owner = "EvanPurkhiser";
    rev = "v${version}";
    hash = "sha256-9/+wzPTaQ5PfPiqTZ5EuHdswXJgfgnvAul/FeeDbbJA=";
  };

  buildInputs = [ ffmpeg_7 libkeyfinder fftw ];

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
