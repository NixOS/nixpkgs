{stdenv, fetchurl, x11, libjpeg, libpng, libXmu, freetype, pam}:

stdenv.mkDerivation {
  name = "slim-1.2.6";
  src = fetchurl {
    url = http://download.berlios.de/slim/slim-1.2.6.tar.gz;
    sha256 = "0plcmm955rnv67sx67ka6dccanr4rfzwzvsj6lnr8kqdip4522jg";
  };
  patches = [
    # Allow the paths of the configuration file and theme directory to
    # be set at runtime.
    ./runtime-paths.patch
    # PAM support from
    # http://developer.berlios.de/patch/?func=detailpatch&patch_id=1979&group_id=2663
    ./pam.patch
  ];
  buildInputs = [x11 libjpeg libpng libXmu freetype pam];
  NIX_CFLAGS_COMPILE = "-I${freetype}/include/freetype2";
  preBuild = "
    substituteInPlace Makefile --replace /usr /no-such-path
    makeFlagsArray=(CC=gcc CXX=g++ PREFIX=$out MANDIR=$out/share/man CFGDIR=$out/etc)
  ";

  meta = {
    homepage = http://slim.berlios.de;
  };
}
