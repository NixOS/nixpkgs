{ stdenv, fetchFromGitHub, pkgconfig, gtk2, SDL, fontconfig, freetype, imlib2, SDL_image, libGLU_combined,
libXmu, freeglut, pcre, dbus-glib, glib, librsvg, freeimage, libxslt,
qtbase, qtquickcontrols, qtsvg, qtdeclarative, qtlocation, qtsensors, qtmultimedia, qtspeech, espeak,
cairo, gdk_pixbuf, pango, atk, patchelf, fetchurl, bzip2,
python, gettext, quesoglc, gd, postgresql, cmake, shapelib, SDL_ttf, fribidi}:

stdenv.mkDerivation rec {
  name = "navit-${version}";
  version = "0.5.1";

  src = fetchFromGitHub {
    owner = "navit-gps";
    repo = "navit";
    rev = "v${version}";
    sha256 = "0jf2gjh2sszr5y5c2wvamfj2qggi2y5k3ynb32pak9vhf5xyl5xj";
  };

  sample_map = fetchurl {
    url = "http://www.navit-project.org/maps/osm_bbox_11.3,47.9,11.7,48.2.osm.bz2";
    name = "sample_map.bz2";
    sha256 = "0vg6b6rhsa2cxqj4rbhfhhfss71syhnfa6f1jg2i2d7l88dm5x7d";
  };

  #hardeningDisable = [ "format" ];
  NIX_CFLAGS_COMPILE = [ "-I${SDL.dev}/include/SDL" ];

  # TODO: fix speech options.
  cmakeFlags = [ "-DSAMPLE_MAP=n " "-DCMAKE_BUILD_TYPE=RelWithDebInfo" "-Dsupport/espeak=FALSE" "-Dspeech/qt5_espeak=FALSE" ];

  buildInputs = [ gtk2 SDL fontconfig freetype imlib2 SDL_image libGLU_combined freeimage libxslt
    libXmu freeglut python gettext quesoglc gd postgresql qtbase SDL_ttf fribidi pcre qtquickcontrols
    espeak qtmultimedia qtspeech qtsensors qtlocation qtdeclarative qtsvg dbus-glib librsvg shapelib glib 
    cairo gdk_pixbuf pango atk ];

  nativeBuildInputs = [ pkgconfig cmake patchelf bzip2 ];

  # we dont want blank screen by defaut
  postInstall = ''
    # emulate DSAMPLE_MAP
    mkdir -p $out/share/navit/maps/maps
    bzcat "${sample_map}" | $out/bin/maptool "$out/share/navit/maps/osm_bbox_11.3,47.9,11.7,48.2.bin"
  '';

  # TODO: fix upstream?
  postFixup = ''
    for lib in $(find "$out/lib/navit/" -iname "*.so" ); do
      patchelf --set-rpath ${stdenv.lib.makeLibraryPath buildInputs} $lib
    done
  '';

  meta = with stdenv.lib; {
    homepage = http://www.navit-project.org;
    description = "Car navigation system with routing engine using OSM maps";
    license = licenses.gpl2;
    maintainers = [ maintainers.genesis ];
    platforms = platforms.linux;
  };
}
