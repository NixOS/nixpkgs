{ stdenv, fetchFromGitHub, pkgconfig, gtk2, fontconfig, freetype, imlib2
, SDL_image, libGLU, libGL, libXmu, freeglut, pcre, dbus, dbus-glib, glib
, librsvg, freeimage, libxslt, cairo, gdk-pixbuf, pango
, atk, patchelf, fetchurl, bzip2, python, gettext, quesoglc
, gd, cmake, shapelib, SDL_ttf, fribidi, makeWrapper
, qtquickcontrols, qtmultimedia, qtspeech, qtsensors
, qtlocation, qtdeclarative, qtsvg
, qtSupport ? false, qtbase #need to fix qt_qpainter
, sdlSupport ? true, SDL
, xkbdSupport ? true, xkbd
, espeakSupport ? true, espeak
, postgresqlSupport ? false, postgresql
, speechdSupport ? false, speechd ? null
}:

assert speechdSupport -> speechd != null;

with stdenv.lib;
stdenv.mkDerivation rec {
  pname = "navit";
  version = "0.5.3";

  src = fetchFromGitHub {
    owner = "navit-gps";
    repo = "navit";
    rev = "v${version}";
    sha256 = "071drvqzxpxbfh0lf0lra5a97rv8ny40l96n9xl0dx0s8w30j61i";
  };

  sample_map = fetchurl {
    url = "http://www.navit-project.org/maps/osm_bbox_11.3,47.9,11.7,48.2.osm.bz2";
    name = "sample_map.bz2";
    sha256 = "0vg6b6rhsa2cxqj4rbhfhhfss71syhnfa6f1jg2i2d7l88dm5x7d";
  };

  patches = [ ./CMakeLists.txt.patch ];

  NIX_CFLAGS_COMPILE = toString (optional sdlSupport "-I${SDL.dev}/include/SDL"
    ++ optional speechdSupport "-I${speechd}/include/speech-dispatcher");

  # we choose only cmdline and speech-dispatcher speech options.
  # espeak builtins is made for non-cmdline OS as winCE
  cmakeFlags = [
    "-DSAMPLE_MAP=n " "-DCMAKE_BUILD_TYPE=Release"
    "-Dspeech/qt5_espeak=FALSE" "-Dsupport/espeak=FALSE"
  ];

  buildInputs = [
    gtk2 fontconfig freetype imlib2 libGLU libGL freeimage
    libxslt libXmu freeglut python gettext quesoglc gd
    fribidi pcre  dbus dbus-glib librsvg shapelib glib
    cairo gdk-pixbuf pango atk
  ] ++ optionals sdlSupport [ SDL SDL_ttf SDL_image ]
    ++ optional postgresqlSupport postgresql
    ++ optional speechdSupport speechd
    ++ optionals qtSupport [
      qtquickcontrols qtmultimedia qtspeech qtsensors
      qtbase qtlocation qtdeclarative qtsvg
  ];

  nativeBuildInputs = [ makeWrapper pkgconfig cmake patchelf bzip2 ];

  # we dont want blank screen by defaut
  postInstall = ''
    # emulate DSAMPLE_MAP
    mkdir -p $out/share/navit/maps/
    bzcat "${sample_map}" | $out/bin/maptool "$out/share/navit/maps/osm_bbox_11.3,47.9,11.7,48.2.bin"
  '';

  # TODO: fix upstream?
  libPath = stdenv.lib.makeLibraryPath ([ stdenv.cc.libc ] ++ buildInputs );
  postFixup =
  ''
    find "$out/lib" -type f -name "*.so" -exec patchelf --set-rpath $libPath {} \;

    wrapProgram $out/bin/navit \
      --prefix PATH : ${makeBinPath (
        optional xkbdSupport xkbd
        ++ optional espeakSupport espeak
        ++ optional speechdSupport speechd ) }
  '';

  meta = {
    homepage = https://www.navit-project.org;
    description = "Car navigation system with routing engine using OSM maps";
    license = licenses.gpl2;
    maintainers = [ maintainers.genesis ];
    platforms = platforms.linux;
  };
}
