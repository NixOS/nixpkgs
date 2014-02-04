{ stdenv, fetchurl, groff, rake, makeWrapper }:

stdenv.mkDerivation rec {
  name = "hub-${version}";
  version = "1.11.1";

  src = fetchurl {
    url = "https://github.com/github/hub/archive/v${version}.tar.gz";
    sha256 = "09wqxxzgrgcx6p3n3bhrb5ka3194qfwnli5j3frv37448hx6wd4n";
  };

  buildInputs = [ rake makeWrapper ];

  installPhase = ''
    rake install "prefix=$out"
  '';

  fixupPhase = ''
    wrapProgram $out/bin/hub --prefix PATH : ${groff}/bin
  '';

  meta = {
    description = "A GitHub specific wrapper for git";
    homepage = "http://defunkt.io/hub/";
    license = stdenv.lib.licenses.mit;
  };
}
