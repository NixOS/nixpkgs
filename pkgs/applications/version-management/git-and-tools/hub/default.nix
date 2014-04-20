{ stdenv, fetchurl, groff, rake, makeWrapper }:

stdenv.mkDerivation rec {
  name = "hub-${version}";
  version = "1.12.0";

  src = fetchurl {
    url = "https://github.com/github/hub/archive/v${version}.tar.gz";
    sha256 = "1lbl4dl7483q320qw4jm6mqq4dbbk3xncypxgg86zcdigxvw6igv";
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
