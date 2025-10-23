{
  lib,
  stdenv,
  fetchFromGitHub,
  gettext,
  libiconv,
  bison,
  ncurses,
  perl,
  autoreconfHook,
}:

stdenv.mkDerivation {
  pname = "lifelines";
  version = "0-unstable-2025-01-05";

  src = fetchFromGitHub {
    owner = "lifelines";
    repo = "lifelines";
    rev = "fbc92b6585e5f642c59a5317a0f4d4573f51b2d6";
    sha256 = "sha256-G/Sj3E8K4QDR4fJcipCKTXpQU19LOfOeLBp5k7uPwk4=";
  };

  buildInputs = [
    gettext
    libiconv
    ncurses
    perl
  ];
  nativeBuildInputs = [
    autoreconfHook
    bison
  ];

  meta = {
    description = "Genealogy tool with ncurses interface";
    homepage = "https://lifelines.github.io/lifelines/";
    license = lib.licenses.mit;
    maintainers = [ lib.maintainers.disassembler ];
    platforms = lib.platforms.linux;
  };
}
