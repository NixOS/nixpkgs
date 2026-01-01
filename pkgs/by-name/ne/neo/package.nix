{
  lib,
  stdenv,
  fetchurl,
  ncurses,
}:

stdenv.mkDerivation rec {
  pname = "neo";
  version = "0.6.1";

  src = fetchurl {
    url = "https://github.com/st3w/neo/releases/download/v${version}/neo-${version}.tar.gz";
    sha256 = "sha256-pV5O1e/QpK8kjRYBinqq07YX7x06wF0pKiWKOKr0ank=";
  };

  buildInputs = [ ncurses ];

<<<<<<< HEAD
  meta = {
    description = ''Simulates the digital rain from "The Matrix"'';
    license = lib.licenses.gpl3Plus;
=======
  meta = with lib; {
    description = ''Simulates the digital rain from "The Matrix"'';
    license = licenses.gpl3Plus;
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
    longDescription = ''
      neo recreates the digital rain effect from "The Matrix". Streams of random
      characters will endlessly scroll down your terminal screen.
    '';
    homepage = "https://github.com/st3w/neo";
    platforms = ncurses.meta.platforms;
<<<<<<< HEAD
    maintainers = [ lib.maintainers.abbe ];
=======
    maintainers = [ maintainers.abbe ];
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
    mainProgram = "neo";
  };
}
