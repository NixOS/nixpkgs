{ stdenv, fetchFromGitHub, ncurses, asciidoc, docbook_xsl, libxslt, pkgconfig }:

with stdenv.lib;

stdenv.mkDerivation rec {
  pname = "kakoune-unwrapped";
  version = "2020.01.16";
  src = fetchFromGitHub {
    repo = "kakoune";
    owner = "mawww";
    rev = "v${version}";
    sha256 = "16v6z1nzj54j19fraxhb18jdby4zfs1br91gxpg9s2s4nsk0km0b";
  };
  nativeBuildInputs = [ pkgconfig ];
  buildInputs = [ ncurses asciidoc docbook_xsl libxslt ];
  makeFlags = [ "debug=no" ];

  postPatch = ''
    export PREFIX=$out
    cd src
    sed -ie 's#--no-xmllint#--no-xmllint --xsltproc-opts="--nonet"#g' Makefile
  '';

  preConfigure = ''
    export version="v${version}"
  '';

  doInstallCheckPhase = true;
  installCheckPhase = ''
    $out/bin/kak -ui json -E "kill 0"
  '';

  meta = {
    homepage = "http://kakoune.org/";
    description = "A vim inspired text editor";
    license = licenses.publicDomain;
    maintainers = with maintainers; [ vrthra ];
    platforms = platforms.unix;
  };
}
