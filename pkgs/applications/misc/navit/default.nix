{ stdenv, fetchsvn, pkgconfig, gtk, SDL, fontconfig, freetype, imlib2, SDL_image, mesa,
libXmu, freeglut, python, gettext, quesoglc, gd, postgresql, cmake, qt4, SDL_ttf, fribidi}:
stdenv.mkDerivation rec {
  name = "navit-svn-3537";

  src = fetchsvn {
    url = svn://svn.code.sf.net/p/navit/code/trunk/navit;
    rev = 5576;
    sha256 = "1xx62l5srfhh9cfi7n3pxj8hpcgr1rpa0hzfmbrqadzv09z36723";
  };

  hardeningDisable = [ "format" ];

  buildInputs = [ gtk SDL fontconfig freetype imlib2 SDL_image mesa
    libXmu freeglut python gettext quesoglc gd postgresql qt4 SDL_ttf fribidi ];

  nativeBuildInputs = [ pkgconfig cmake ];

  NIX_CFLAGS_COMPILE = [ "-I${SDL.dev}/include/SDL" ];

  cmakeFlags = [ "-DSAMPLE_MAP=n" ];

  meta = {
    homepage = http://www.navit-project.org/;
    description = "Car navigation system with routing engine using OSM maps";
    license = stdenv.lib.licenses.gpl2;
    maintainers = with stdenv.lib.maintainers; [ viric ];
    platforms = with stdenv.lib.platforms; linux;
  };
}
