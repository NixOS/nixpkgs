{ stdenv
, lib
, fetchurl
, substituteAll
, autoreconfHook
, pkg-config
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
, libjxl
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
, libexif
, gettext
, makeWrapper
, gtk-doc
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
, desktopToDarwinBundle
, AppKit
, Cocoa
, gtk-mac-integration-gtk2
, withPython ? false
, python2
}:

let
  python = python2.withPackages (pp: [ pp.pygtk ]);
in stdenv.mkDerivation (finalAttrs: {
  pname = "gimp";
  version = "2.10.34";

  outputs = [ "out" "dev" ];

  src = fetchurl {
    url = "http://download.gimp.org/pub/gimp/v${lib.versions.majorMinor finalAttrs.version}/gimp-${finalAttrs.version}.tar.bz2";
    sha256 = "hABGQtNRs5ikKTzX/TWSBEqUTwW7UoUO5gaPJHxleqM=";
  };

  patches = [
    # to remove compiler from the runtime closure, reference was retained via
    # gimp --version --verbose output
    (substituteAll {
      src = ./remove-cc-reference.patch;
      cc_version = stdenv.cc.cc.name;
    })

    # Use absolute paths instead of relying on PATH
    # to make sure plug-ins are loaded by the correct interpreter.
    ./hardcode-plugin-interpreters.patch
  ];

  nativeBuildInputs = [
    autoreconfHook # hardcode-plugin-interpreters.patch changes Makefile.am
    pkg-config
    intltool
    gettext
    makeWrapper
    gtk-doc
  ] ++ lib.optionals stdenv.isDarwin [
    desktopToDarwinBundle
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
    libjxl
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
  ] ++ lib.optionals withPython [
    python
    # Duplicated here because python.withPackages does not expose the dev output with pkg-config files
    python2.pkgs.pygtk
  ];

  # needed by gimp-2.0.pc
  propagatedBuildInputs = [
    gegl
  ];

  configureFlags = [
    "--without-webkit" # old version is required
    "--disable-check-update"
    "--with-bug-report-url=https://github.com/NixOS/nixpkgs/issues/new"
    "--with-icc-directory=/run/current-system/sw/share/color/icc"
    # fix libdir in pc files (${exec_prefix} needs to be passed verbatim)
    "--libdir=\${exec_prefix}/lib"
  ] ++ lib.optionals (!withPython) [
    "--disable-python" # depends on Python2 which was EOLed on 2020-01-01
  ];

  enableParallelBuilding = true;

  doCheck = true;

  env = {
    NIX_CFLAGS_COMPILE = lib.optionalString stdenv.isDarwin "-DGDK_OSX_BIG_SUR=16";

    # Check if librsvg was built with --disable-pixbuf-loader.
    PKG_CONFIG_GDK_PIXBUF_2_0_GDK_PIXBUF_MODULEDIR = "${librsvg}/${gdk-pixbuf.moduleDir}";
  };

  preConfigure = ''
    # The check runs before glib-networking is registered
    export GIO_EXTRA_MODULES="${glib-networking}/lib/gio/modules:$GIO_EXTRA_MODULES"
  '';

  postFixup = ''
    wrapProgram $out/bin/gimp-${lib.versions.majorMinor finalAttrs.version} \
      --set GDK_PIXBUF_MODULE_FILE "$GDK_PIXBUF_MODULE_FILE"
  '';

  passthru = {
    # The declarations for `gimp-with-plugins` wrapper,
    # used for determining plug-in installation paths
    majorVersion = "${lib.versions.major finalAttrs.version}.0";
    targetLibDir = "lib/gimp/${finalAttrs.passthru.majorVersion}";
    targetDataDir = "share/gimp/${finalAttrs.passthru.majorVersion}";
    targetPluginDir = "${finalAttrs.passthru.targetLibDir}/plug-ins";
    targetScriptDir = "${finalAttrs.passthru.targetDataDir}/scripts";

    # probably its a good idea to use the same gtk in plugins ?
    gtk = gtk2;

    python2Support = withPython;
  };

  meta = with lib; {
    description = "The GNU Image Manipulation Program";
    homepage = "https://www.gimp.org/";
    maintainers = with maintainers; [ jtojnar ];
    license = licenses.gpl3Plus;
    platforms = platforms.unix;
    mainProgram = "gimp";
  };
})
