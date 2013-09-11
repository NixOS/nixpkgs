{ stdenv, fetchurl, groff, rake, makeWrapper }:

stdenv.mkDerivation rec {
  name = "hub-${version}";
  version = "1.10.6";

  src = fetchurl {
    url = "https://github.com/github/hub/archive/v${version}.tar.gz";
    sha256 = "0vfl1iq1927in81vd7zvp7yqqzay7pciyj87s83qfxrqyjpxn609";
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
