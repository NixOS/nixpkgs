{ stdenv, fetchurl, fetchpatch, pkgconfig, perl, perlXMLParser, libXft
, libpng, zlib, popt, boehmgc, libxml2, libxslt, glib, gtkmm2
, glibmm, libsigcxx, lcms, boost, gettext, makeWrapper, intltool
, gsl, python2, poppler, imagemagick, libwpg, librevenge
, libvisio, libcdr, libexif, automake114x, cmake
}:

let 
  python2Env = python2.withPackages(ps: with ps; [ numpy lxml ]);
in

stdenv.mkDerivation rec {
  name = "inkscape-0.92.0";

  src = fetchurl {
    url = "https://inkscape.org/gallery/item/10552/${name}.tar.bz2";
    sha256 = "0mmssxnxsvb3bpm7ck5pqvwyacrz1nkyacs571jx8j04l1cw3d5q";
  };

  postPatch = ''
    patchShebangs share/extensions
    patchShebangs fix-roff-punct
  '';

  # Python is used at run-time to execute scripts, e.g., those from
  # the "Effects" menu.
  propagatedBuildInputs = [ python2Env ];

  buildInputs = [
    pkgconfig perl perlXMLParser libXft libpng zlib popt boehmgc
    libxml2 libxslt glib gtkmm2 glibmm libsigcxx lcms boost gettext
    makeWrapper intltool gsl poppler imagemagick libwpg librevenge
    libvisio libcdr libexif automake114x cmake
  ];

  enableParallelBuilding = true;

  postInstall = ''
    # Make sure PyXML modules can be found at run-time.
    rm "$out/share/icons/hicolor/icon-theme.cache"
  '';

  meta = with stdenv.lib; {
    license = "GPL";
    homepage = http://www.inkscape.org;
    description = "Vector graphics editor";
    platforms = platforms.all;
    longDescription = ''
      Inkscape is a feature-rich vector graphics editor that edits
      files in the W3C SVG (Scalable Vector Graphics) file format.

      If you want to import .eps files install ps2edit.
    '';
  };
}
