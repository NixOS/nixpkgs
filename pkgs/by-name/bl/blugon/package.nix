{
  lib,
  stdenv,
  fetchFromGitHub,
  python3,
  libx11,
  libxrandr,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "blugon";
  version = "1.12.1";

  src = fetchFromGitHub {
    owner = "jumper149";
    repo = "blugon";
    tag = finalAttrs.version;
    sha256 = "1i67v8jxvavgax3dwvns200iwwdcvgki04liq0x64q52lg0vrh7m";
  };

  buildInputs = [
    python3
    libx11
    libxrandr
  ];

  # Remove at next release
  # https://github.com/jumper149/blugon/commit/d262cd05
  postPatch = ''
    sed -i 's,CC = gcc,CC ?= gcc,g' backends/scg/Makefile
  '';

  makeFlags = [ "PREFIX=$(out)" ];

  meta = {
    description = "Simple and configurable Blue Light Filter for X";
    longDescription = ''
      blugon is a simple and fast Blue Light Filter, that is highly configurable and provides a command line interface.
      The program can be run just once or as a daemon (manually or via systemd).
      There are several different backends available.
      blugon calculates the screen color from your local time and configuration.
    '';
    license = lib.licenses.asl20;
    homepage = "https://github.com/jumper149/blugon";
    platforms = lib.platforms.unix;
    maintainers = with lib.maintainers; [ jumper149 ];
    mainProgram = "blugon";
  };
})
