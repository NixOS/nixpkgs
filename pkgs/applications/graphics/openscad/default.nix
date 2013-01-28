{stdenv, fetchgit, qt4, bison, flex, eigen, boost, mesa, glew, opencsg, cgal
  , mpfr, gmp
  }:

stdenv.mkDerivation rec {
  version = "git-20121213";
  name = "openscad-${version}";
  # src = fetchurl {
  #   url = "https://github.com/downloads/openscad/openscad/${name}.src.tar.gz";
  #   sha256 = "0gaqwzxbbzc21lhb4y26j8g0g28dhrwrgkndizp5ddab5axi4zjh";
  # };
  src = fetchgit {
    url = "https://github.com/openscad/openscad.git";
    rev = "c0612a9ed0899c96963e04c848a59b0164a689a2";
    sha256  = "1zqiwk1cjbj7sng9sdarbrs0zxkn9fsa84dyv8n0zlyh40s7kvw2";
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
