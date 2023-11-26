{ stdenv
, lib
, boehmgc
, boost
, cairo
, cmake
, desktopToDarwinBundle
, fetchurl
, gettext
, ghostscript
, glib
, glibmm
, gobject-introspection
, gsl
, gspell
, gtk-mac-integration
, gtkmm3
, gdk-pixbuf
, imagemagick
, lcms
, lib2geom
, libcdr
, libexif
, libpng
, librevenge
, librsvg
, libsigcxx
, libsoup
, libvisio
, libwpg
, libXft
, libxml2
, libxslt
, ninja
, perlPackages
, pkg-config
, poppler
, popt
, potrace
, python3
, substituteAll
, wrapGAppsHook
, libepoxy
, zlib
}:
let
  python3Env = python3.withPackages
    (ps: with ps; [
      appdirs
      beautifulsoup4
      cachecontrol
    ]
    # CacheControl requires extra runtime dependencies for FileCache
    # https://gitlab.com/inkscape/extras/extension-manager/-/commit/9a4acde6c1c028725187ff5972e29e0dbfa99b06
    ++ cachecontrol.optional-dependencies.filecache
    ++ [
      numpy
      lxml
      packaging
      pillow
      scour
      pyparsing
      pyserial
      requests
      pygobject3
    ] ++ inkex.propagatedBuildInputs);
in
stdenv.mkDerivation rec {
  pname = "inkscape";
  version = "1.3.2";

  src = fetchurl {
    url = "https://inkscape.org/release/inkscape-${version}/source/archive/xz/dl/inkscape-${version}.tar.xz";
    sha256 = "sha256-29GETcRD/l4Q0+mohxROX7ciOFL/8ZHPte963qsOCGs=";
  };

  # Inkscape hits the ARGMAX when linking on macOS. It appears to be
  # CMake’s ARGMAX check doesn’t offer enough padding for NIX_LDFLAGS.
  # Setting strictDeps it avoids duplicating some dependencies so it
  # will leave us under ARGMAX.
  strictDeps = true;

  patches = [
    (substituteAll {
      src = ./fix-python-paths.patch;
      # Python is used at run-time to execute scripts,
      # e.g., those from the "Effects" menu.
      python3 = "${python3Env}/bin/python";
    })
    (substituteAll {
      # Fix path to ps2pdf binary
      src = ./fix-ps2pdf-path.patch;
      inherit ghostscript;
    })
  ];

  postPatch = ''
    patchShebangs share/extensions
    patchShebangs share/templates
    patchShebangs man/fix-roff-punct

    # double-conversion is a dependency of 2geom
    substituteInPlace CMakeScripts/DefineDependsandFlags.cmake \
      --replace 'find_package(DoubleConversion REQUIRED)' ""
  '';

  nativeBuildInputs = [
    pkg-config
    cmake
    ninja
    python3Env
    glib # for setup hook
    gdk-pixbuf # for setup hook
    wrapGAppsHook
    gobject-introspection
  ] ++ (with perlPackages; [
    perl
    XMLParser
  ]) ++ lib.optionals stdenv.isDarwin [
    desktopToDarwinBundle
  ];

  buildInputs = [
    boehmgc
    boost
    gettext
    glib
    glibmm
    gsl
    gtkmm3
    imagemagick
    lcms
    lib2geom
    libcdr
    libexif
    libpng
    librevenge
    librsvg # for loading icons
    libsigcxx
    libsoup
    libvisio
    libwpg
    libXft
    libxml2
    libxslt
    perlPackages.perl
    poppler
    popt
    potrace
    python3Env
    zlib
    libepoxy
  ] ++ lib.optionals (!stdenv.isDarwin) [
    gspell
  ] ++ lib.optionals stdenv.isDarwin [
    cairo
    gtk-mac-integration
  ];

  # Make sure PyXML modules can be found at run-time.
  postInstall = lib.optionalString stdenv.isDarwin ''
    for f in $out/lib/inkscape/*.dylib; do
      ln -s $f $out/lib/$(basename $f)
    done
  '';

  meta = with lib; {
    description = "Vector graphics editor";
    homepage = "https://www.inkscape.org";
    license = licenses.gpl3Plus;
    maintainers = [ maintainers.jtojnar ];
    platforms = platforms.all;
    mainProgram = "inkscape";
    longDescription = ''
      Inkscape is a feature-rich vector graphics editor that edits
      files in the W3C SVG (Scalable Vector Graphics) file format.

      If you want to import .eps files install ps2edit.
    '';
  };
}
