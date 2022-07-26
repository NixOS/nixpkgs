{ stdenv
, lib
, boehmgc
, boost
, cairo
, cmake
, fetchurl
, gettext
, ghostscript
, glib
, glibmm
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
, zlib
}:
let
  python3Env = python3.withPackages
    (ps: with ps; [
      appdirs
      beautifulsoup4
      cachecontrol
      numpy
      lxml
      pillow
      scour
      pyserial
      requests
      pygobject3
    ] ++ inkex.propagatedBuildInputs);
in
stdenv.mkDerivation rec {
  pname = "inkscape";
  version = "1.2.1";

  src = fetchurl {
    url = "https://media.inkscape.org/dl/resources/file/inkscape-${version}.tar.xz";
    sha256 = "Rs59oOunykutwdtw6cu2fgrfm7NCaH3G4ItcohuNTBs=";
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
    substituteInPlace share/extensions/eps_input.inx \
      --replace "location=\"path\">ps2pdf" "location=\"absolute\">${ghostscript}/bin/ps2pdf"
    substituteInPlace share/extensions/ps_input.inx \
      --replace "location=\"path\">ps2pdf" "location=\"absolute\">${ghostscript}/bin/ps2pdf"
    substituteInPlace share/extensions/ps_input.py \
      --replace "call('ps2pdf'" "call('${ghostscript}/bin/ps2pdf'"
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
  ] ++ (with perlPackages; [
    perl
    XMLParser
  ]);

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
  ] ++ lib.optionals (!stdenv.isDarwin) [
    gspell
  ] ++ lib.optionals stdenv.isDarwin [
    cairo
    gtk-mac-integration
  ];

  # Make sure PyXML modules can be found at run-time.
  postInstall = lib.optionalString stdenv.isDarwin ''
    install_name_tool -change $out/lib/libinkscape_base.dylib $out/lib/inkscape/libinkscape_base.dylib $out/bin/inkscape
    install_name_tool -change $out/lib/libinkscape_base.dylib $out/lib/inkscape/libinkscape_base.dylib $out/bin/inkview
  '';

  meta = with lib; {
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
