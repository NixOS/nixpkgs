{ stdenv, fetchFromGitHub, ncurses, boost, asciidoc, docbook_xsl, libxslt }:

with stdenv.lib;

stdenv.mkDerivation rec {
  name = "kakoune-nightly-${version}";
  version = "2017-02-09";
  src = fetchFromGitHub {
    repo = "kakoune";
    owner = "mawww";
    rev = "9ba1665e58ee84b6596d89e6ef75f7c32e7c6c14";
    sha256 = "1l25mzq64a481qlsyh25rzp5rzajrkx4dq29677z85lnjqn30wbi";
  };
  buildInputs = [ ncurses boost asciidoc docbook_xsl libxslt ];

  buildPhase = ''
    sed -ie 's#--no-xmllint#--no-xmllint --xsltproc-opts="--nonet"#g' src/Makefile
    substituteInPlace src/Makefile --replace "boost_regex-mt" "boost_regex"
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
    platforms = platforms.unix;
  };
}
