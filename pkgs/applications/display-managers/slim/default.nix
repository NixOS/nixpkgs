{stdenv, fetchurl, x11, libjpeg, libpng, libXmu, freetype}:

stdenv.mkDerivation {
  name = "slim-1.2.6";
  src = fetchurl {
    url = http://download.berlios.de/slim/slim-1.2.6.tar.gz;
    sha256 = "0plcmm955rnv67sx67ka6dccanr4rfzwzvsj6lnr8kqdip4522jg";
  };
  patches = [./runtime-paths.patch];
  buildInputs = [x11 libjpeg libpng libXmu freetype];
  NIX_CFLAGS_COMPILE = "-I${freetype}/include/freetype2";
  preBuild = "
    makeFlagsArray=(CC=gcc CXX=g++ PREFIX=$out MANDIR=$out/share/man CFGDIR=$out/etc)
  ";
}
