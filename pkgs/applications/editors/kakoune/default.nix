{ stdenv, fetchFromGitHub, ncurses, boost, asciidoc, docbook_xsl, libxslt }:

with stdenv.lib;

stdenv.mkDerivation rec {
  name = "kakoune-unstable-${version}";
  version = "2017-10-31";
  src = fetchFromGitHub {
    repo = "kakoune";
    owner = "mawww";
    rev = "706202218700c989b760942170515c7f3757290b"; 
    sha256 = "09nrrzffms7iaa8jmwfqjfn3m2z5462qdy6lhjnyj7f56gxyw9ci"; 
  };
  buildInputs = [ ncurses boost asciidoc docbook_xsl libxslt ];
  
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
