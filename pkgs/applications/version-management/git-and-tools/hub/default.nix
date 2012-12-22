{ stdenv, fetchgit, groff, rake, makeWrapper }:

stdenv.mkDerivation rec {
  name = "hub-${version}";
  version = "1.10.3";

  src = fetchgit {
    url = "git://github.com/defunkt/hub.git";
    rev = "refs/tags/v${version}";
    sha256 = "0j0krmf0sf09hhw3nsn0w1y97d67762g4qrc8080bwcx38lbyvbg";
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
