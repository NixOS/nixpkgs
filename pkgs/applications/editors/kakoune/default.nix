{ stdenv, fetchFromGitHub, ncurses, boost, asciidoc, docbook_xsl, libxslt }:

with stdenv.lib;

stdenv.mkDerivation rec {
  name = "kakoune-nightly-${version}";
  version = "2016-12-10";
  src = fetchFromGitHub {
    repo = "kakoune";
    owner = "mawww";
    rev = "e44129577a010ebb4dc609b806104d3175659074";
    sha256 = "1jkpbk6wa9x5nlv002y1whv6ddhqawxzbp3jcbzcb51cg8bz0b1l";
  };
  buildInputs = [ ncurses boost asciidoc docbook_xsl libxslt ];

  buildPhase = ''
    sed -ie 's#--no-xmllint#--no-xmllint --xsltproc-opts="--nonet"#g' src/Makefile
    export PREFIX=$out
    (cd src && make )
  '';

  installPhase = ''
    (cd src && make install)
  '';

  meta = {
    homepage = http://kakoune.org/;
    description = "A vim inspired text editor";
    license = licenses.publicDomain;
    maintainers = with maintainers; [ vrthra ];
    platforms = platforms.linux;
  };
}
