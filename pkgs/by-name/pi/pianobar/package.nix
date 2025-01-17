{
  fetchFromGitHub,
  lib,
  stdenv,
  pkg-config,
  libao,
  json_c,
  libgcrypt,
  ffmpeg,
  curl,
}:

stdenv.mkDerivation rec {
  pname = "pianobar";
  version = "2022.04.01-unstable-2024-08-16";

  src = fetchFromGitHub {
    owner = "PromyLOPh";
    repo = "pianobar";
    rev = "41ac06c8585dc535c4b1737b4c2943bb3fe7beb0";
    hash = "sha256-5LTZ6J9bvfsnpD/bGuojekutFVdH9feWLF+nLFvkeOA=";
  };

  nativeBuildInputs = [ pkg-config ];
  buildInputs = [
    libao
    json_c
    libgcrypt
    ffmpeg
    curl
  ];

  makeFlags = [ "PREFIX=$(out)" ];

  CC = "gcc";
  CFLAGS = "-std=c99";

  meta = with lib; {
    description = "Console front-end for Pandora.com";
    homepage = "https://6xq.net/pianobar/";
    platforms = platforms.unix;
    license = licenses.mit; # expat version
    mainProgram = "pianobar";
  };
}
