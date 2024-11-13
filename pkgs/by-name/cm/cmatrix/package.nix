{ lib, stdenv, fetchFromGitHub, autoreconfHook, ncurses }:

stdenv.mkDerivation rec {
  pname = "cmatrix";
  version = "2.0";

  src = fetchFromGitHub {
    owner = "abishekvashok";
    repo = "cmatrix";
    rev = "v${version}";
    sha256 = "1h9jz4m4s5l8c3figaq46ja0km1gimrkfxm4dg7mf4s84icmasbm";
  };

  nativeBuildInputs = [ autoreconfHook ];
  buildInputs = [ ncurses ];

  meta = with lib; {
    description = "Simulates the falling characters theme from The Matrix movie";
    license = licenses.gpl3;
    longDescription = ''
      CMatrix simulates the display from "The Matrix" and is based
      on the screensaver from the movie's website.
    '';
    homepage = "https://github.com/abishekvashok/cmatrix";
    platforms = ncurses.meta.platforms;
    maintainers = [ maintainers.AndersonTorres ];
    mainProgram = "cmatrix";
  };
}
