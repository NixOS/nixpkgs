{ stdenv, fetchurl, ncurses, asciidoc, xmlto, docbook_xsl }:

stdenv.mkDerivation {
  name = "tig-1.0";
  src = fetchurl {
    url = "http://jonas.nitro.dk/tig/releases/tig-1.0.tar.gz";
    md5 = "a2d414d1cebbc9cd4f3d545bc6f225c6";
  };
  buildInputs = [ncurses asciidoc xmlto docbook_xsl];
  installPhase = ''
    make install
    make install-doc
  '';
  meta = {
    description = "Tig is a git repository browser that additionally can act as a pager for output from various git commands";
    homepage = "http://jonas.nitro.dk/tig/";
    license = "GPLv2";
  };
}
