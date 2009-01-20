{stdenv, fetchurl, qt, libXext, libX11, sourceByName}:

stdenv.mkDerivation rec {
  name = "qgit-git";
  meta =
  {
    license = "GPLv2";
    homepage = "http://digilander.libero.it/mcostalba/";
    description = "Graphical front-end to Git";
  };
  src = sourceByName "qgit";
  buildInputs = [qt libXext libX11];
  buildPhase = ''
    qmake PREFIX=$out
    make
  '';
}
