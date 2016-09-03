{ stdenv, fetchurl, pkgconfig, intltool, babl, gegl, gtk, glib, gdk_pixbuf
, pango, cairo, freetype, fontconfig, lcms, libpng, libjpeg, poppler, libtiff
, webkit, libmng, librsvg, libwmf, zlib, libzip, ghostscript, aalib, jasper
, python, pygtk, libart_lgpl, libexif, gettext, xorg, wrapPython }:

stdenv.mkDerivation rec {
  name = "gimp-${version}";
  version = "2.8.18";

  # This declarations for `gimp-with-plugins` wrapper,
  # (used for determining $out/lib/gimp/${majorVersion}/ paths)
  majorVersion = "2.0";
  targetPluginDir = "$out/lib/gimp/${majorVersion}/plug-ins";
  targetScriptDir = "$out/lib/gimp/${majorVersion}/scripts";

  src = fetchurl {
    url = "http://download.gimp.org/pub/gimp/v2.8/${name}.tar.bz2";
    sha256 = "0halh6sl3d2j9gahyabj6h6r3yyldcy7sfb4qrfazpkqqr3j5p9r";
  };

  buildInputs =
    [ pkgconfig intltool babl gegl gtk glib gdk_pixbuf pango cairo
      freetype fontconfig lcms libpng libjpeg poppler libtiff webkit
      libmng librsvg libwmf zlib libzip ghostscript aalib jasper
      python pygtk libart_lgpl libexif gettext xorg.libXpm
      wrapPython
    ];

  pythonPath = [ pygtk ];

  postFixup = ''
    wrapPythonProgramsIn $out/lib/gimp/2.0/plug-ins/
    wrapProgram $out/bin/gimp \
      --prefix PYTHONPATH : "$PYTHONPATH" \
      --set GDK_PIXBUF_MODULE_FILE "$GDK_PIXBUF_MODULE_FILE"
  '';

  passthru = { inherit gtk; }; # probably its a good idea to use the same gtk in plugins ?

  #configureFlags = [ "--disable-print" ];

  enableParallelBuilding = true;

  # "screenshot" needs this.
  NIX_LDFLAGS = "-rpath ${xorg.libX11.out}/lib"
    + stdenv.lib.optionalString stdenv.isDarwin " -lintl";

  meta = {
    description = "The GNU Image Manipulation Program";
    homepage = http://www.gimp.org/;
    license = stdenv.lib.licenses.gpl3Plus;
    platforms = stdenv.lib.platforms.linux;
  };
}
