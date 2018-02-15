{ stdenv, fetchFromGitHub, ncurses, boost, asciidoc, docbook_xsl, libxslt, pkgconfig }:

with stdenv.lib;

stdenv.mkDerivation rec {
  name = "kakoune-unstable-${version}";
  version = "2017-04-12";
  src = fetchFromGitHub {
    repo = "kakoune";
    owner = "mawww";
    rev = "7482d117cc85523e840dff595134dcb9cdc62207";
    sha256 = "08j611y192n9vln9i94ldlvz3k0sg79dkmfc0b1vczrmaxhpgpfh";
  };
  nativeBuildInputs = [ pkgconfig ];
  buildInputs = [ ncurses boost asciidoc docbook_xsl libxslt ];

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
