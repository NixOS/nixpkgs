{stdenv, fetchurl, qt4, bison, flex, eigen, boost, mesa, glew, opencsg, cgal
  , mpfr, gmp
  }:

stdenv.mkDerivation rec {
  version = "2011.12";
  name = "openscad-${version}";
  src = fetchurl {
    url = "https://github.com/downloads/openscad/openscad/${name}.src.tar.gz";
    sha256 = "0gaqwzxbbzc21lhb4y26j8g0g28dhrwrgkndizp5ddab5axi4zjh";
  };

  buildInputs = [qt4 bison flex eigen boost mesa glew opencsg cgal gmp mpfr];

  configurePhase = ''
    export NIX_CFLAGS_COMPILE="$NIX_CFLAGS_COMPILE -I ${eigen}/include/eigen2 "
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
