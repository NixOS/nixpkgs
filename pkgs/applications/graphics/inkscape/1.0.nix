{ stdenv
, fetchFromGitLab
, substituteAll
, boehmgc
, boost
, cmake
, double-conversion
, gdl
, gettext
, glib
, glib-networking
, glibmm
, gsl
, gtkspell3
, gtkmm3
, harfbuzz
, hicolor-icon-theme
, imagemagick
, lcms2
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

  extensions = fetchFromGitLab {
    owner = "inkscape";
    repo = "extensions";
    rev = "cc4bedea16a964d91596cae5808664b13a2535c9";
    sha256 = "RlY3nAm0IYxTWWmCMXvqxQnIbkv3V7xyBJ5z0vXqPrI=";
  };
in
stdenv.mkDerivation rec {
  pname = "inkscape";
  version = "1.0-rc1";

  src = fetchFromGitLab {
    owner = "inkscape";
    repo = "inkscape";
    rev = stdenv.lib.toUpper (stdenv.lib.replaceStrings [ "-" "." ] [ "_" "_" ] "${pname}-${version}");
    sha256 = "m83hz0NJhYYA+hHDkkbWrlrp/kF4/+m45acw3ZYIm5w=";
  };

  patches = [
    (substituteAll {
      src = ./fix-paths.patch;
      # Python is used at run-time to execute scripts, e.g., those from
      # the "Effects" menu.
      python = "${python3Env}/bin/python";
    })
  ];

  # Inkscape hits the ARGMAX when linking on macOS. It appears to be
  # CMake’s ARGMAX check doesn’t offer enough padding for NIX_LDFLAGS.
  # Setting strictDeps it avoids duplicating some dependencies so it
  # will leave us under ARGMAX.
  strictDeps = true;

  postPatch = ''
    cp -r ${extensions}/* share/extensions

    patchShebangs \
      man/fix-roff-punct \
      share/templates/create_defaults.pl
  '';

  nativeBuildInputs = [
    pkg-config
    cmake
    ninja
    wrapGAppsHook
    python3Env
    gettext
  ] ++ (with perlPackages; [
    perl
    XMLParser
  ]);

  buildInputs = [
    boehmgc
    boost
    double-conversion
    gdl
    glib
    glib-networking
    glibmm
    gsl
    gtkspell3
    gtkmm3
    harfbuzz
    hicolor-icon-theme
    imagemagick
    lcms2
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
  ];

  # Make sure PyXML modules can be found at run-time.
  postInstall = stdenv.lib.optionalString stdenv.isDarwin ''
    install_name_tool -change $out/lib/libinkscape_base.dylib $out/lib/inkscape/libinkscape_base.dylib $out/bin/inkscape
    install_name_tool -change $out/lib/libinkscape_base.dylib $out/lib/inkscape/libinkscape_base.dylib $out/bin/inkview
  '';

  meta = with stdenv.lib; {
    description = "Vector graphics editor";
    homepage = https://www.inkscape.org;
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
