{ stdenv, fetchurl, pkgconfig, gtk, SDL, fontconfig, freetype, imlib2, SDL_image, mesa,
libXmu, freeglut, python, gettext, quesoglc, gd, postgresql }:
stdenv.mkDerivation rec {
  name = "navit-0.1.1";

  src = fetchurl {
    url = mirror://sourceforge/navit/navit-0.1.1.tar.gz;
    sha256 = "1zm1nlh2jhslanpxm07cgp8g6mkna5zcv6ahh4wg1f7x0rabylic";
  };

  buildInputs = [ pkgconfig gtk SDL fontconfig freetype imlib2 SDL_image mesa
    libXmu freeglut python gettext quesoglc gd postgresql ];

  configureFlags = [ "--disable-samplemap" ];

  meta = {
    homepage = http://www.navit-project.org/;
    description = "Car navigation system with routing engine using OSM maps";
    license = "GPLv2";
    maintainers = with stdenv.lib.maintainers; [ viric ];
    platforms = with stdenv.lib.platforms; linux;
  };
}
