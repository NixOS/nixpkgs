{ stdenv
, lib
, fetchFromGitHub
, substituteAll
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
, python2
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
, libxslt
, automake
, autoconf
, libtool
, makeWrapper
, autoreconfHook
, gtk-doc
, graphviz
}:
let
  python = python2.withPackages (pp: [ pp.pygtk ]);
in
stdenv.mkDerivation rec {
  pname = "glimpse";
  version = "0.2.0";

  outputs = [ "out" "dev" ];

  src = fetchFromGitHub {
    owner = "glimpse-editor";
    repo = "Glimpse";
    rev = "v${version}";
    sha256 = "sha256-qbZQmAo7fuJWWbn0QTyxAwAenZOdsGueUq5/3IV8Njc=";
  };

  patches = [
    # to remove compiler from the runtime closure, reference was retained via
    # gimp --version --verbose output
    (substituteAll {
      src = ./remove-cc-reference.patch;
      cc_version = stdenv.cc.cc.name;
    })
    ../gimp/hardcode-plugin-interpreters.patch
  ];

  postPatch = ''
    ln -s ${gtk-doc}/share/gtk-doc/data/gtk-doc.make .
  '';

  nativeBuildInputs = [
    autoreconfHook
    pkg-config
    intltool
    gettext
    automake
    autoconf
    makeWrapper
    gtk-doc
    libxslt
    libtool
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

  # Check if librsvg was built with --disable-pixbuf-loader.
  PKG_CONFIG_GDK_PIXBUF_2_0_GDK_PIXBUF_MODULEDIR = "${librsvg}/${gdk-pixbuf.moduleDir}";

  preAutoreconf = ''
    # The check runs before glib-networking is registered
    export GIO_EXTRA_MODULES="${glib-networking}/lib/gio/modules:$GIO_EXTRA_MODULES"
  '';

  postFixup = ''
    wrapProgram $out/bin/glimpse-${lib.versions.majorMinor version} \
      --set GDK_PIXBUF_MODULE_FILE "$GDK_PIXBUF_MODULE_FILE" \
      --prefix PATH ":" ${ lib.makeBinPath [ graphviz ] }
  '';

  passthru = rec {
    # The declarations for `glimpse-with-plugins` wrapper,
    # used for determining plug-in installation paths
    majorVersion = "2.0";
    targetPluginDir = "lib/glimpse/${majorVersion}/plug-ins";
    targetScriptDir = "share/glimpse/${majorVersion}/scripts";
    targetDataDir = "share/gimp/${majorVersion}";
    targetLibDir = "lib/gimp/${majorVersion}";

    # probably its a good idea to use the same gtk in plugins ?
    gtk = gtk2;
  };

  configureFlags = [
    "--without-webkit" # old version is required
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
    description = "An open source image editor based on the GNU Image Manipulation Program";
    longDescription = ''
      Glimpse is an open source image editor based on the GNU Image Manipulation Program (GIMP). The goal is to experiment with new ideas and expand the use of free software.
    '';
    homepage = "https://glimpse-editor.org";
    maintainers = with maintainers; [ ashkitten erictapen ];
    license = licenses.gpl3Plus;
    platforms = platforms.unix;
  };
}
