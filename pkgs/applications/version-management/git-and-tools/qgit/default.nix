{stdenv, fetchurl, qt, libXext, libX11}:

stdenv.mkDerivation rec {
  name = "qgit-2.3";
  meta =
  {
    license = "GPLv2";
    homepage = "http://digilander.libero.it/mcostalba/";
    description = "Graphical front-end to Git";
    platforms = stdenv.lib.platforms.all;
  };
  src = fetchurl
  {
    url = "mirror://sourceforge/qgit/${name}.tar.bz2";
    sha256 = "a5fdd7e27fea376790eed787e22f4863eb9d2fe0217fd98b9fdbcf47a45bdc64";
  };
  buildInputs = [qt libXext libX11];
  configurePhase = "qmake PREFIX=$out";
  installPhase = ''
    install -s -D -m 755 bin/qgit "$out/bin/qgit"
  '';
}
