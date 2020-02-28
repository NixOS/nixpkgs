{ stdenv
, lib
, fetchurl
, substituteAll
, pkgconfig
, intltool
, babl
, gegl
, gtk2
, glib
, gdk-pixbuf
, isocodes
, pango
, cairo
, freetype
, fontconfig
, lcms
, libpng
, libjpeg
, poppler
, poppler_data
, libtiff
, libmng
, librsvg
, libwmf
, zlib
, libzip
, ghostscript
, aalib
, shared-mime-info
, python2Packages
, libexif
, gettext
, xorg
, glib-networking
, libmypaint
, gexiv2
, harfbuzz
, mypaint-brushes1
, libwebp
, libheif
, libgudev
, openexr
, AppKit
, Cocoa
, gtk-mac-integration-gtk2
}:

let
  inherit (python2Packages) pygtk wrapPython python;
in stdenv.mkDerivation rec {
  pname = "gimp";
  version = "2.10.18";

  outputs = [ "out" "dev" ];

  src = fetchurl {
    url = "http://download.gimp.org/pub/gimp/v${lib.versions.majorMinor version}/${pname}-${version}.tar.bz2";
    sha256 = "Zb/hEejuv/093jAWzLUH+ZSNJmPZSXy0ONm7YJ4R1xY=";
  };

  nativeBuildInputs = [
    pkgconfig
    intltool
    gettext
    wrapPython
  ];

  buildInputs = [
    babl
    gegl
    gtk2
    glib
    gdk-pixbuf
    pango
    cairo
    gexiv2
    harfbuzz
    isocodes
    freetype
    fontconfig
    lcms
    libpng
    libjpeg
    poppler
    poppler_data
    libtiff
    openexr
    libmng
    librsvg
    libwmf
    zlib
    libzip
    ghostscript
    aalib
    shared-mime-info
    libwebp
    libheif
    python
    pygtk
    libexif
    xorg.libXpm
    glib-networking
    libmypaint
    mypaint-brushes1
  ] ++ lib.optionals stdenv.isDarwin [
    AppKit
    Cocoa
    gtk-mac-integration-gtk2
  ] ++ lib.optionals stdenv.isLinux [
    libgudev
  ];

  # needed by gimp-2.0.pc
  propagatedBuildInputs = [
    gegl
  ];

  pythonPath = [ pygtk ];

  # Check if librsvg was built with --disable-pixbuf-loader.
  PKG_CONFIG_GDK_PIXBUF_2_0_GDK_PIXBUF_MODULEDIR = "${librsvg}/${gdk-pixbuf.moduleDir}";

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
    wrapProgram $out/bin/gimp-${lib.versions.majorMinor version} \
      --prefix PYTHONPATH : "$PYTHONPATH" \
      --set GDK_PIXBUF_MODULE_FILE "$GDK_PIXBUF_MODULE_FILE"
  '';

  passthru = rec {
    # The declarations for `gimp-with-plugins` wrapper,
    # used for determining plug-in installation paths
    majorVersion = "${lib.versions.major version}.0";
    targetPluginDir = "lib/gimp/${majorVersion}/plug-ins";
    targetScriptDir = "share/gimp/${majorVersion}/scripts";

    # probably its a good idea to use the same gtk in plugins ?
    gtk = gtk2;
  };

  configureFlags = [
    "--without-webkit" # old version is required
    "--disable-check-update"
    "--with-bug-report-url=https://github.com/NixOS/nixpkgs/issues/new"
    "--with-icc-directory=/run/current-system/sw/share/color/icc"
    # fix libdir in pc files (${exec_prefix} needs to be passed verbatim)
    "--libdir=\${exec_prefix}/lib"
  ];

  # on Darwin,
  # test-eevl.c:64:36: error: initializer element is not a compile-time constant
  doCheck = !stdenv.isDarwin;

  enableParallelBuilding = true;

  meta = with lib; {
    description = "The GNU Image Manipulation Program";
    homepage = "https://www.gimp.org/";
    maintainers = with maintainers; [ jtojnar ];
    license = licenses.gpl3Plus;
    platforms = platforms.unix;
  };
}
