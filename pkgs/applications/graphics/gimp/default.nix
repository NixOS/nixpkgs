{ stdenv, fetchurl, substituteAll, pkgconfig, intltool, babl, gegl, gtk2, glib, gdk_pixbuf, isocodes
, pango, cairo, freetype, fontconfig, lcms, libpng, libjpeg, poppler, poppler_data, libtiff
, libmng, librsvg, libwmf, zlib, libzip, ghostscript, aalib, shared-mime-info
, python2Packages, libexif, gettext, xorg, glib-networking, libmypaint, gexiv2
, harfbuzz, mypaint-brushes, libwebp, libheif, libgudev, openexr
, AppKit, Cocoa, gtk-mac-integration-gtk2, cf-private }:

let
  inherit (python2Packages) pygtk wrapPython python;
in stdenv.mkDerivation rec {
  pname = "gimp";
  version = "2.10.10";

  src = fetchurl {
    url = "http://download.gimp.org/pub/gimp/v${stdenv.lib.versions.majorMinor version}/${pname}-${version}.tar.bz2";
    sha256 = "0xwck5nbpb945s1cyij3kfqw1pchbhx8i5vf5hgywyjw4r1z5l8j";
  };

  nativeBuildInputs = [ pkgconfig intltool gettext wrapPython ];
  propagatedBuildInputs = [ gegl ]; # needed by gimp-2.0.pc
  buildInputs = [
    babl gegl gtk2 glib gdk_pixbuf pango cairo gexiv2 harfbuzz isocodes
    freetype fontconfig lcms libpng libjpeg poppler poppler_data libtiff openexr
    libmng librsvg libwmf zlib libzip ghostscript aalib shared-mime-info libwebp libheif
    python pygtk libexif xorg.libXpm glib-networking libmypaint mypaint-brushes
  ] ++ stdenv.lib.optionals stdenv.isDarwin [
    # cf-private is needed to get some things not in swift-corefoundation.
    # For instance _OBJC_CLASS_$_NSArray is missing.
    AppKit Cocoa gtk-mac-integration-gtk2 cf-private
  ] ++ stdenv.lib.optionals stdenv.isLinux [ libgudev ];

  pythonPath = [ pygtk ];

  # Check if librsvg was built with --disable-pixbuf-loader.
  PKG_CONFIG_GDK_PIXBUF_2_0_GDK_PIXBUF_MODULEDIR = "${librsvg}/${gdk_pixbuf.moduleDir}";

  preConfigure = ''
    # The check runs before glib-networking is registered
    export GIO_EXTRA_MODULES="${glib-networking}/lib/gio/modules:$GIO_EXTRA_MODULES"
  '';

  patches = [
    # to remove compiler from the runtime closure, reference was retained via
    # gimp --version --verbose output
    (substituteAll {
      src = ./remove-cc-reference.patch;
      cc_version = stdenv.cc.cc.name;
    })
  ];

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
    "--with-icc-directory=/run/current-system/sw/share/color/icc"
  ];

  # on Darwin,
  # test-eevl.c:64:36: error: initializer element is not a compile-time constant
  doCheck = !stdenv.isDarwin;

  enableParallelBuilding = true;

  meta = with stdenv.lib; {
    description = "The GNU Image Manipulation Program";
    homepage = https://www.gimp.org/;
    maintainers = with maintainers; [ jtojnar ];
    license = licenses.gpl3Plus;
    platforms = platforms.unix;
  };
}
