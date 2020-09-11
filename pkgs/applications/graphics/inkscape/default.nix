{ stdenv
, boehmgc
, boost
, cairo
, cmake
, double-conversion
, fetchurl
, gettext
, gdl
, glib
, glib-networking
, glibmm
, gsl
, gtk-mac-integration
, gtkmm3
, gtkspell3
, gdk-pixbuf
, imagemagick
, lcms
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
, zlib
}:
let
  python3Env = python3.withPackages
    (ps: with ps; [
      numpy
      lxml
      scour
    ]);
in
stdenv.mkDerivation rec {
  pname = "inkscape";
  version = "1.0";

  src = fetchurl {
    url = "https://media.inkscape.org/dl/resources/file/${pname}-${version}.tar.xz";
    sha256 = "1fwl7yjkykqb86555k4fm24inhc40mrvxqwgl2v2vi9alv8j7hc9";
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
  ];

  postPatch = ''
    patchShebangs share/extensions
    patchShebangs share/templates
    patchShebangs man/fix-roff-punct
  '';

  nativeBuildInputs = [
    pkg-config
    cmake
    ninja
    python3Env
    glib # for setup hook
    gdk-pixbuf # for setup hook
    wrapGAppsHook
  ] ++ (with perlPackages; [
    perl
    XMLParser
  ]);

  buildInputs = [
    boehmgc
    boost
    double-conversion
    gdl
    gettext
    glib
    glib-networking
    glibmm
    gsl
    gtkmm3
    imagemagick
    lcms
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
  ] ++ stdenv.lib.optionals (!stdenv.isDarwin) [
    gtkspell3
  ] ++ stdenv.lib.optionals stdenv.isDarwin [
    cairo
    gtk-mac-integration
  ];

  # Make sure PyXML modules can be found at run-time.
  postInstall = stdenv.lib.optionalString stdenv.isDarwin ''
    install_name_tool -change $out/lib/libinkscape_base.dylib $out/lib/inkscape/libinkscape_base.dylib $out/bin/inkscape
    install_name_tool -change $out/lib/libinkscape_base.dylib $out/lib/inkscape/libinkscape_base.dylib $out/bin/inkview
  '';

  meta = with stdenv.lib; {
    description = "Vector graphics editor";
    homepage = "https://www.inkscape.org";
    license = licenses.gpl3Plus;
    maintainers = [ maintainers.jtojnar ];
    platforms = platforms.all;
    longDescription = ''
      Inkscape is a feature-rich vector graphics editor that edits
      files in the W3C SVG (Scalable Vector Graphics) file format.

      If you want to import .eps files install ps2edit.
    '';
  };
}
