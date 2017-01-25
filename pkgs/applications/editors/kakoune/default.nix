{ stdenv, fetchFromGitHub, ncurses, boost, asciidoc, docbook_xsl, libxslt }:

with stdenv.lib;

stdenv.mkDerivation rec {
  name = "kakoune-nightly-${version}";
  version = "2016-12-30";
  src = fetchFromGitHub {
    repo = "kakoune";
    owner = "mawww";
    rev = "76c58aa022a896dc170c207ff821992ee354d934";
    sha256 = "0hgpcp6444cyg4bm0a9ypywjwfh19qpqpfr5w0wcd2y3clnsvsdz";
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
