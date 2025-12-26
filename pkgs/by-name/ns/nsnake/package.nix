{
  stdenv,
  fetchFromGitHub,
  lib,
  ncurses,
}:

stdenv.mkDerivation rec {
  pname = "nsnake";
  version = "3.0.1";

  src = fetchFromGitHub {
    owner = "alexdantas";
    repo = "nSnake";
    rev = "v${version}";
    sha256 = "sha256-MixwIhyymruruV8G8PjmR9EoZBpaDVBCKBccSFL0lS8=";
  };

  buildInputs = [ ncurses ];

  makeFlags = [ "PREFIX=$(out)" ];

  meta = {
    description = "ncurses based snake game for the terminal";
    mainProgram = "nsnake";
    homepage = "https://github.com/alexdantas/nSnake";
    license = lib.licenses.gpl3Plus;
    maintainers = with lib.maintainers; [ clerie ];
  };
}
