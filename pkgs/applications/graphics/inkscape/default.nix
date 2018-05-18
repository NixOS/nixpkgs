{ stdenv, fetchurl, fetchpatch, pkgconfig, perl, perlXMLParser, libXft
, libpng, zlib, popt, boehmgc, libxml2, libxslt, glib, gtkmm2
, glibmm, libsigcxx, lcms, boost, gettext, makeWrapper
, gsl, python2, poppler, imagemagick, libwpg, librevenge
, libvisio, libcdr, libexif, potrace, autoreconfHook
, intltool
, icu # Not needed for building with CMake
, lib
}:

# Note that originally this Nix expression used CMake to build but
# this led to errors on MacOS of "Too many arguments". Inkscape
# supports autoconf and we will use this for now on.

let
  python2Env = python2.withPackages(ps: with ps; [ numpy lxml ]);
in

stdenv.mkDerivation rec {
  name = "inkscape-0.92.3";

  src = fetchurl {
    url = "https://media.inkscape.org/dl/resources/file/${name}.tar.bz2";
    sha256 = "1chng2yw8dsjxc9gf92aqv7plj11cav8ax321wmakmv5bb09cch6";
  };

  postPatch = ''
    patchShebangs share/extensions
    patchShebangs fix-roff-punct

    # XXX: Not needed for CMake:
    ${lib.optionalString (!stdenv.isDarwin) ''
      patchShebangs share/filters
      patchShebangs share/palettes
      patchShebangs share/patterns
      patchShebangs share/symbols
      patchShebangs share/templates
    ''}

    # Python is used at run-time to execute scripts, e.g., those from
    # the "Effects" menu.
    substituteInPlace src/extension/implementation/script.cpp \
      --replace '"python-interpreter", "python"' '"python-interpreter", "${python2Env}/bin/python"'
  '';

  nativeBuildInputs = [ pkgconfig autoreconfHook intltool ];
  buildInputs = [
    perl perlXMLParser libXft libpng zlib popt boehmgc
    libxml2 libxslt glib gtkmm2 glibmm libsigcxx lcms boost gettext
    makeWrapper gsl poppler imagemagick libwpg librevenge
    libvisio libcdr libexif potrace python2Env icu
  ];

  # To avoid non-deterministic build failure using make.
  # When switching back to cmake turn parallel back on, see #40046.
  enableParallelBuilding = false;

  preConfigure = ''
    intltoolize -f
  '';

  postInstall = ''
    # Make sure PyXML modules can be found at run-time.
    rm "$out/share/icons/hicolor/icon-theme.cache"
  '';

  meta = with lib; {
    license = "GPL";
    homepage = https://www.inkscape.org;
    description = "Vector graphics editor";
    platforms = platforms.all;
    longDescription = ''
      Inkscape is a feature-rich vector graphics editor that edits
      files in the W3C SVG (Scalable Vector Graphics) file format.

      If you want to import .eps files install ps2edit.
    '';
    maintainers = with maintainers; [ matthewbauer ];
  };
}
