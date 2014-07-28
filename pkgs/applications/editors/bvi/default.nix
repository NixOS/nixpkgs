{ stdenv, fetchurl, ncurses }:

stdenv.mkDerivation {
  name = "bvi-1.3.2";

  src = fetchurl {
    url = mirror://sourceforge/bvi/bvi-1.3.2.src.tar.gz;
    sha256 = "110wxqnyianqamxq4y53drqqxb9vp4k2fcvic45qggvlqkqhlfgz";
  };

  buildInputs = [ ncurses ];

  meta = { 
    description = "Hex editor with vim style keybindings";
    homepage = http://bvi.sourceforge.net/download.html;
    license = stdenv.lib.licenses.gpl2;
  };
}
