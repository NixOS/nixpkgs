{
  lib,
  stdenv,
  fetchFromGitHub,
}:

stdenv.mkDerivation {
  pname = "shncpd";
  version = "2016-06-22";

  src = fetchFromGitHub {
    owner = "jech";
    repo = "shncpd";
    rev = "62ef688db7a6535ce11e66c8c93ab64a1bb09484";
    hash = "sha256-DkW5eeuqHXn1gQmkJU2X05iRaOLKCv4OrFIwHc9RR+o=";
  };

  preConfigure = ''
    makeFlags=( "PREFIX=$out" )
  '';

  meta = {
    description = "Simple, stupid and slow HNCP daemon";
    homepage = "https://www.irif.univ-paris-diderot.fr/~jch/software/homenet/shncpd.html";
    license = lib.licenses.mit;
    platforms = lib.platforms.linux;
    maintainers = [ lib.maintainers.fpletz ];
    mainProgram = "shncpd";
  };
}
