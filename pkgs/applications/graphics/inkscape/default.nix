{ stdenv, fetchurl, pkgconfig, perl, perlXMLParser, gtk, libXft
, libpng, zlib, popt, boehmgc, libxml2, libxslt, glib, gtkmm
, glibmm, libsigcxx, lcms, boost, gettext, makeWrapper, intltool
, gsl, python, pyxml, lxml, poppler, imagemagick, libwpg }:

stdenv.mkDerivation rec {
  name = "inkscape-0.48.5";

  src = fetchurl {
    url = "mirror://sourceforge/inkscape/${name}.tar.bz2";
    sha256 = "0sfr7a1vr1066rrkkqbqvcqs3gawalj68ralnhd6k87jz62fcv1b";
  };

  patches = [ ./configure-python-libs.patch ];

  postPatch = stdenv.lib.optionalString doCheck
    ''sed -i 's:#include "../../src:#include "src:' src/cxxtests.cpp'';

  propagatedBuildInputs = [
    # Python is used at run-time to execute scripts, e.g., those from
    # the "Effects" menu.
    python pyxml lxml
  ];

  buildInputs = [
    pkgconfig perl perlXMLParser gtk libXft libpng zlib popt boehmgc
    libxml2 libxslt glib gtkmm glibmm libsigcxx lcms boost gettext
    makeWrapper intltool gsl poppler imagemagick libwpg
  ];

  configureFlags = "--with-python";

  enableParallelBuilding = true;
  doCheck = true;
  checkFlags = "-j1";

  postInstall = ''
    # Make sure PyXML modules can be found at run-time.
    for i in "$out/bin/"*
    do
      wrapProgram "$i" --prefix PYTHONPATH :      \
       "$(toPythonPath ${pyxml}):$(toPythonPath ${lxml})"  \
       --prefix PATH : ${python}/bin ||  \
        exit 2
    done
    rm $out/share/icons/hicolor/icon-theme.cache
  '';

  NIX_LDFLAGS = "-lX11";

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
