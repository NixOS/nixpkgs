{
  lib,
  stdenv,
  fetchFromGitHub,
  ffmpeg,
  libkeyfinder,
  fftw,
}:

stdenv.mkDerivation rec {
  pname = "keyfinder-cli";
  version = "1.1.2";

  src = fetchFromGitHub {
    repo = "keyfinder-cli";
    owner = "EvanPurkhiser";
    rev = "v${version}";
    hash = "sha256-9/+wzPTaQ5PfPiqTZ5EuHdswXJgfgnvAul/FeeDbbJA=";
  };

  buildInputs = [
    ffmpeg
    libkeyfinder
    fftw
  ];

  makeFlags = [ "PREFIX=$(out)" ];

  enableParallelBuilding = true;

<<<<<<< HEAD
  meta = {
=======
  meta = with lib; {
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
    inherit (src.meta) homepage;
    description = "Musical key detection for digital audio (command-line tool)";
    longDescription = ''
      This small utility is the automation-oriented DJ's best friend. By making
      use of Ibrahim Sha'ath's high quality libKeyFinder library, it can be
      used to estimate the musical key of many different audio formats.
    '';
<<<<<<< HEAD
    license = lib.licenses.gpl3Plus;
    platforms = lib.platforms.unix;
=======
    license = licenses.gpl3Plus;
    platforms = platforms.unix;
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
    mainProgram = "keyfinder-cli";
  };
}
