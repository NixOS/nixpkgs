{ stdenv, fetchFromGitHub, ncurses, boost, asciidoc, docbook_xsl, libxslt, pkgconfig }:

with stdenv.lib;

stdenv.mkDerivation rec {
  name = "kakoune-unstable-${version}";
  version = "2018-05-21";
  src = fetchFromGitHub {
    repo = "kakoune";
    owner = "mawww";
    rev = "878d2a4bdb674a5e7703a66e530520f48efba641";
    sha256 = "0pwy6ilsb62s1792gjyvhvq8shj60l8lx26b58zvpfb54an4s6rk";
  };
  nativeBuildInputs = [ pkgconfig ];
  buildInputs = [ ncurses asciidoc docbook_xsl libxslt ];
  makeFlags = [ "debug=no" ];

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
