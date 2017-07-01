{ stdenv, fetchurl, pkgconfig, intltool, babl, gegl, gtk2, glib, gdk_pixbuf
, pango, cairo, freetype, fontconfig, lcms, libpng, libjpeg, poppler, libtiff
, webkit, libmng, librsvg, libwmf, zlib, libzip, ghostscript, aalib, jasper
, python2Packages, libart_lgpl, libexif, gettext, xorg
, AppKit, Cocoa, gtk-mac-integration }:

let
  inherit (python2Packages) pygtk wrapPython python;
in stdenv.mkDerivation rec {
  name = "gimp-${version}";
  version = "2.8.22";

  # This declarations for `gimp-with-plugins` wrapper,
  # (used for determining $out/lib/gimp/${majorVersion}/ paths)
  majorVersion = "2.0";
  targetPluginDir = "$out/lib/gimp/${majorVersion}/plug-ins";
  targetScriptDir = "$out/lib/gimp/${majorVersion}/scripts";

  src = fetchurl {
    url = "http://download.gimp.org/pub/gimp/v2.8/${name}.tar.bz2";
    sha256 = "12k3lp938qdc9cqj29scg55f3bb8iav2fysd29w0s49bqmfa71wi";
  };

  buildInputs =
    [ pkgconfig intltool babl gegl gtk2 glib gdk_pixbuf pango cairo
      freetype fontconfig lcms libpng libjpeg poppler libtiff webkit
      libmng librsvg libwmf zlib libzip ghostscript aalib jasper
      python pygtk libart_lgpl libexif gettext xorg.libXpm
      wrapPython
    ]
    ++ stdenv.lib.optionals stdenv.isDarwin [ AppKit Cocoa gtk-mac-integration ];

  pythonPath = [ pygtk ];

  postFixup = ''
    wrapPythonProgramsIn $out/lib/gimp/2.0/plug-ins/
    wrapProgram $out/bin/gimp \
      --prefix PYTHONPATH : "$PYTHONPATH" \
      --set GDK_PIXBUF_MODULE_FILE "$GDK_PIXBUF_MODULE_FILE"
  '';

  passthru = { gtk = gtk2; }; # probably its a good idea to use the same gtk in plugins ?

  #configureFlags = [ "--disable-print" ];

  enableParallelBuilding = true;

  # "screenshot" needs this.
  NIX_LDFLAGS = "-rpath ${xorg.libX11.out}/lib"
    + stdenv.lib.optionalString stdenv.isDarwin " -lintl";

  meta = {
    description = "The GNU Image Manipulation Program";
    homepage = http://www.gimp.org/;
    license = stdenv.lib.licenses.gpl3Plus;
    platforms = stdenv.lib.platforms.unix;
  };
}
