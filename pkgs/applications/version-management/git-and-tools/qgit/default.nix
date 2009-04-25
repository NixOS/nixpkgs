{stdenv, fetchurl, qt, libXext, libX11}:

stdenv.mkDerivation rec {
  name = "qgit-2.2";
  meta =
  {
    license = "GPLv2";
    homepage = "http://digilander.libero.it/mcostalba/";
    description = "Graphical front-end to Git";
  };
  src = fetchurl
  {
    url = "mirror://sourceforge/qgit/${name}.tar.bz2";
    sha256 = "82adcc59b2a9d3a3e54eef9e6a76ac6583e459b6f5c97050d26b0593d11c3d32";
  };
  buildInputs = [qt libXext libX11];
  configurePhase = "qmake PREFIX=$out";
  installPhase = ''
    install -s -D -m 755 bin/qgit "$out/bin/qgit"
  '';
}
