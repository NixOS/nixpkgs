{ stdenv, fetchFromGitHub, ncurses, boost, asciidoc, docbook_xsl, libxslt }:

with stdenv.lib;

stdenv.mkDerivation rec {
  name = "kakoune-nightly-${version}";
  version = "2016-07-26";
  src = fetchFromGitHub {
    repo = "kakoune";
    owner = "mawww";
    rev = "0d2c5072b083a893843e4fa87f9f702979069e14";
    sha256 = "01qqs5yr9xvvklg3gg45lgnyh6gji28m854mi1snzvjd7fksf50n";
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
