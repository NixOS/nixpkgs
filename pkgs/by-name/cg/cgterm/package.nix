{
  lib,
  stdenv,
  fetchFromGitHub,
  SDL,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "cg-term";
  version = "1.7b2";

  src = fetchFromGitHub {
    owner = "MagerValp";
    repo = "CGTerm";
    rev = "01e35d64c29bccee52211b0afc66035a10e4792a"; # no tags
    hash = "sha256-Gk7t9wnVCRWwnqcItS3j031VqJnBqk6rHw1SABtzqfE=";
  };

  buildInputs = [
    SDL
  ];

  makeFlags = [
    "CC:=$(CC)"
    "PREFIX=$(out)"
  ];

  meta = with lib; {
    description = "C/G telnet client for C64 BBS's";
    homepage = "https://github.com/MagerValp/CGTerm";
    license = licenses.bsd2;
    maintainers = with maintainers; [ matthewcroughan ];
    mainProgram = "cg-term";
    platforms = platforms.all;
  };
})
