{ stdenv, fetchurl, pkgconfig, intltool, babl, gegl, gtk2, glib, gdk_pixbuf, isocodes
, pango, cairo, freetype, fontconfig, lcms, libpng, libjpeg, poppler, poppler_data, libtiff
, libmng, librsvg, libwmf, zlib, libzip, ghostscript, aalib, shared-mime-info
, python2Packages, libexif, gettext, xorg, glib-networking, libmypaint, gexiv2
, harfbuzz, mypaint-brushes, libwebp, libheif, libgudev, openexr
, AppKit, Cocoa, gtk-mac-integration }:

let
  inherit (python2Packages) pygtk wrapPython python;
in stdenv.mkDerivation rec {
  name = "gimp-${version}";
  version = "2.10.6";

  src = fetchurl {
    url = "http://download.gimp.org/pub/gimp/v${stdenv.lib.versions.majorMinor version}/${name}.tar.bz2";
    sha256 = "07qh2ljbza2mph1gh8sicn27qihhj8hx3ivvry2874cfh8ghgj2f";
  };

  nativeBuildInputs = [ pkgconfig intltool gettext wrapPython ];
  propagatedBuildInputs = [ gegl ]; # needed by gimp-2.0.pc
  buildInputs = [
    babl gegl gtk2 glib gdk_pixbuf pango cairo gexiv2 harfbuzz isocodes
    freetype fontconfig lcms libpng libjpeg poppler poppler_data libtiff openexr
    libmng librsvg libwmf zlib libzip ghostscript aalib shared-mime-info libwebp libheif
    python pygtk libexif xorg.libXpm glib-networking libmypaint mypaint-brushes
  ] ++ stdenv.lib.optionals stdenv.isDarwin [ AppKit Cocoa gtk-mac-integration ]
    ++ stdenv.lib.optionals stdenv.isLinux [ libgudev ];

  pythonPath = [ pygtk ];

  # Check if librsvg was built with --disable-pixbuf-loader.
  PKG_CONFIG_GDK_PIXBUF_2_0_GDK_PIXBUF_MODULEDIR = "${librsvg}/${gdk_pixbuf.moduleDir}";

  preConfigure = ''
    # The check runs before glib-networking is registered
    export GIO_EXTRA_MODULES="${glib-networking}/lib/gio/modules:$GIO_EXTRA_MODULES"
  '';

  postFixup = ''
    wrapPythonProgramsIn $out/lib/gimp/${passthru.majorVersion}/plug-ins/
    wrapProgram $out/bin/gimp-${stdenv.lib.versions.majorMinor version} \
      --prefix PYTHONPATH : "$PYTHONPATH" \
      --set GDK_PIXBUF_MODULE_FILE "$GDK_PIXBUF_MODULE_FILE"
  '';

  passthru = rec {
    # The declarations for `gimp-with-plugins` wrapper,
    # used for determining plug-in installation paths
    majorVersion = "${stdenv.lib.versions.major version}.0";
    targetPluginDir = "lib/gimp/${majorVersion}/plug-ins";
    targetScriptDir = "lib/gimp/${majorVersion}/scripts";

    # probably its a good idea to use the same gtk in plugins ?
    gtk = gtk2;
  };

  configureFlags = [
    "--without-webkit" # old version is required
    "--with-bug-report-url=https://github.com/NixOS/nixpkgs/issues/new"
    "--with-icc-directory=/var/run/current-system/sw/share/color/icc"
  ];

  doCheck = true;

  enableParallelBuilding = true;

  meta = with stdenv.lib; {
    description = "The GNU Image Manipulation Program";
    homepage = https://www.gimp.org/;
    maintainers = with maintainers; [ jtojnar ];
    license = licenses.gpl3Plus;
    platforms = platforms.unix;
  };
}
