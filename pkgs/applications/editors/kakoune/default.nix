{ stdenv, fetchFromGitHub, ncurses, boost, asciidoc, docbook_xsl, libxslt, pkgconfig }:

with stdenv.lib;

stdenv.mkDerivation rec {
  name = "kakoune-unstable-${version}";
  version = "2018-03-22";
  src = fetchFromGitHub {
    repo = "kakoune";
    owner = "mawww";
    rev = "f8e297acef1be0657b779fea5256f606a6c6a3a3";
    sha256 = "14xmw3lkwzppm9bns55nmyb1lfihzhdyisf6xjqlszdj4mcf94jl";
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
