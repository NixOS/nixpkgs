{ lib, stdenv
, boehmgc
, boost
, cairo
, cmake
, double-conversion
, fetchurl
, fetchpatch
, gettext
, gdl
, ghostscript
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
  version = "1.0.2";

  src = fetchurl {
    url = "https://media.inkscape.org/dl/resources/file/${pname}-${version}.tar.xz";
    sha256 = "sha256-2j4jBRGgjL8h6GcQ0WFFhZT+qHhn6RV7Z+0BoE6ieYo=";
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

    # Fix build with glib 2.68
    # https://gitlab.com/inkscape/inkscape/-/merge_requests/2790
    (fetchpatch {
      url = "https://gitlab.com/inkscape/inkscape/-/commit/eb24388f1730918edd9565d9e5d09340ec0b3b08.patch";
      sha256 = "d2FHRWcOzi0Vsr6t0MuLu3rWpvhFKuuvoXd4/NKUSJI=";
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
  ] ++ lib.optionals (!stdenv.isDarwin) [
    gtkspell3
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
