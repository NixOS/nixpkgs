{
  lib,
  stdenv,
  fetchurl,
  ncurses,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "neo";
  version = "0.6.1";

  src = fetchurl {
    url = "https://github.com/st3w/neo/releases/download/v${finalAttrs.version}/neo-${finalAttrs.version}.tar.gz";
    sha256 = "sha256-pV5O1e/QpK8kjRYBinqq07YX7x06wF0pKiWKOKr0ank=";
  };

  buildInputs = [ ncurses ];

  meta = {
    description = ''Simulates the digital rain from "The Matrix"'';
    license = lib.licenses.gpl3Plus;
    longDescription = ''
      neo recreates the digital rain effect from "The Matrix". Streams of random
      characters will endlessly scroll down your terminal screen.
    '';
    homepage = "https://github.com/st3w/neo";
    platforms = ncurses.meta.platforms;
    maintainers = [ lib.maintainers.abbe ];
    mainProgram = "neo";
  };
})
