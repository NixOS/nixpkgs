{ stdenv, fetchsvn, pkgconfig, gtk, SDL, fontconfig, freetype, imlib2, SDL_image, mesa,
libXmu, freeglut, python, gettext, quesoglc, gd, postgresql, autoconf, automake, libtool, cvs }:
stdenv.mkDerivation rec {
  name = "navit-svn-3537";

  src = fetchsvn {
    url = https://navit.svn.sourceforge.net/svnroot/navit/trunk/navit;
    rev = 3537;
    sha256 = "1ajd439i7z8xm16kqh20qalvafy9miyy4accc8j7w30c4qgc2bb7";
  };

  # 'cvs' is only for the autogen
  buildInputs = [ pkgconfig gtk SDL fontconfig freetype imlib2 SDL_image mesa
    libXmu freeglut python gettext quesoglc gd postgresql
    autoconf automake libtool cvs ];

  preConfigure = ''
    sh ./autogen.sh
  '';

  configureFlags = [ "--disable-samplemap" ];

  meta = {
    homepage = http://www.navit-project.org/;
    description = "Car navigation system with routing engine using OSM maps";
    license = "GPLv2";
    maintainers = with stdenv.lib.maintainers; [ viric ];
    platforms = with stdenv.lib.platforms; linux;
  };
}
