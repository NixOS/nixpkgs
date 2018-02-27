{ stdenv, fetchFromGitHub, ncurses, boost, asciidoc, docbook_xsl, libxslt, pkgconfig }:

with stdenv.lib;

stdenv.mkDerivation rec {
  name = "kakoune-unstable-${version}";
  version = "2018-02-15";
  src = fetchFromGitHub {
    repo = "kakoune";
    owner = "mawww";
    rev = "f5e39972eb525166dc5b1d963067f79990991a75";
    sha256 = "160a302xg6nfzx49dkis6ij20kyzr63kxvcv8ld3l07l8k69g80r";
  };
  nativeBuildInputs = [ pkgconfig ];
  buildInputs = [ ncurses asciidoc docbook_xsl libxslt ];

  postPatch = ''
    export PREFIX=$out
    cd src
    sed -ie 's#--no-xmllint#--no-xmllint --xsltproc-opts="--nonet"#g' Makefile
  '';

  meta = {
    homepage = http://kakoune.org/;
    description = "A vim inspired text editor";
    license = licenses.publicDomain;
    maintainers = with maintainers; [ vrthra ];
    platforms = platforms.unix;
  };
}
