{ lib
, stdenv
, fetchFromGitHub
, zlib
, libdeflate
, isa-l
}:

stdenv.mkDerivation rec {
  pname = "seqtk";
<<<<<<< HEAD
  version = "1.4";
=======
  version = "1.3";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  src = fetchFromGitHub {
    owner = "lh3";
    repo = "seqtk";
    rev = "v${version}";
<<<<<<< HEAD
    hash = "sha256-W6IUn7R9tlnWrKe/qOHJL+43AL4EZB7zj7M5u9l83WE=";
=======
    hash = "sha256-1Hw/lnoFQumuEJg1n2C6vnWkBa+VLiEiDrosghSm360=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };

  buildInputs = [ zlib libdeflate isa-l ];

  makeFlags = [ "CC=cc" ];

  installPhase = ''
    runHook preInstall

    install -Dm755 -t $out/bin seqtk

    runHook postInstall
  '';

  meta = with lib; {
    description = "Toolkit for processing sequences in FASTA/Q formats";
    license = licenses.mit;
    homepage = "https://github.com/lh3/seqtk";
    platforms = platforms.all;
    maintainers = with maintainers; [ bwlang ];
  };
}
