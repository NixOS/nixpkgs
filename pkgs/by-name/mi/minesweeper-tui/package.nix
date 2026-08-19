{
  lib,
  stdenv,
  fetchFromGitHub,
  ncurses,
  pkg-config,
}:

stdenv.mkDerivation {
  pname = "minesweeper-tui";
  version = "0.1.0";

  src = fetchFromGitHub {
    owner = "ZhaolunYin";
    repo = "minesweeper-tui";
    rev = "a6075d3f54ab0e81c94b71e9b7f92b1030603668";
    hash = "sha256-1cY1d3q6+/llsrLRN9UGodvNxXwbUDKuD2a5fxSCy20=";
  };

  strictDeps = true;
  __structuredAttrs = true;

  nativeBuildInputs = [
    pkg-config
  ];

  buildInputs = [
    ncurses
  ];

  installPhase = ''
    install -Dm755 minesweeper $out/bin/minesweeper
  '';

  meta = {
    description = "A TUI Minesweeper game written in C";
    homepage = "https://github.com/ZhaolunYin/minesweeper-tui";
    license = lib.licenses.mit;
    mainProgram = "minesweeper";
    platforms = lib.platforms.linux;
  };
}
