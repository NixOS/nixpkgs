{ stdenv, fetchurl, ncurses, asciidoc, xmlto, docbook_xsl }:

stdenv.mkDerivation rec {
  name = "tig-1.1";
  src = fetchurl {
    url = "http://jonas.nitro.dk/tig/releases/${name}.tar.gz";
    md5 = "adeb797a8320962eeb345a615257cbac";
  };
  buildInputs = [ncurses asciidoc xmlto docbook_xsl];
  installPhase = ''
    make install
    make install-doc
    mkdir -p $out/etc/bash_completion.d/
    cp contrib/tig-completion.bash $out/etc/bash_completion.d/
  '';
  meta = with stdenv.lib; {
    homepage = "http://jonas.nitro.dk/tig/";
    description = "Tig is a git repository browser that additionally can act as a pager for output from various git commands";
    maintainers = [ maintainers.garbas maintainers.bjornfor maintainers.iElectric ];
    license = licenses.gpl2;
    platforms = platforms.linux;
  };
}
