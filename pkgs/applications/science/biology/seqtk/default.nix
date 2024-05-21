{ lib
, stdenv
, fetchFromGitHub
, zlib
, libdeflate
, isa-l
}:

stdenv.mkDerivation rec {
  pname = "seqtk";
  version = "1.4";

  src = fetchFromGitHub {
    owner = "lh3";
    repo = "seqtk";
    rev = "v${version}";
    hash = "sha256-W6IUn7R9tlnWrKe/qOHJL+43AL4EZB7zj7M5u9l83WE=";
  };

  buildInputs = [ zlib libdeflate isa-l ];

  makeFlags = [
    "CC:=$(CC)"
    "BINDIR=$(out)/bin"
  ];

  preInstall = ''
    mkdir -p "$out/bin"
  '';

  meta = with lib; {
    description = "Toolkit for processing sequences in FASTA/Q formats";
    mainProgram = "seqtk";
    license = licenses.mit;
    homepage = "https://github.com/lh3/seqtk";
    platforms = platforms.all;
    maintainers = with maintainers; [ bwlang ];
  };
}
