{stdenv, fetchurl, qt4, bison, flex, eigen, boost, mesa, glew, opencsg, cgal
  , mpfr, gmp
  }:

stdenv.mkDerivation rec {
  version = "2013.01";
  name = "openscad-${version}";

  src = fetchurl {
    url = "https://openscad.googlecode.com/files/${name}.src.tar.gz";
    sha256 = "01r013l8zyfkgmqn05axh3rlfsjwd6j403w5ffl7nby4i2spiw1f";
  };

  buildInputs = [qt4 bison flex eigen boost mesa glew opencsg cgal gmp mpfr];

  configurePhase = ''
    export NIX_CFLAGS_COMPILE="$NIX_CFLAGS_COMPILE -I$(echo ${eigen}/include/eigen*) "
    qmake PREFIX="$out"
  '';

  doCheck = false;

  meta = {
    description = "3D parametric model compiler";
    homepage = "http://openscad.org/";
    platforms = with stdenv.lib.platforms;
      linux;
    maintainers = with stdenv.lib.maintainers; 
      [raskin];
  };
}
