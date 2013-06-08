{ stdenv, fetchurl, pkgconfig, perl, perlXMLParser, gtk, libXft
, libpng, zlib, popt, boehmgc, libxml2, libxslt, glib, gtkmm
, glibmm, libsigcxx, lcms, boost, gettext, makeWrapper, intltool
, gsl, python, pyxml, lxml, poppler, imagemagick, libwpg }:

stdenv.mkDerivation rec {
  name = "inkscape-0.48.4";

  src = fetchurl {
    url = "mirror://sourceforge/inkscape/${name}.tar.bz2";
    sha256 = "17aiibgdwjqpjc38f0yr2sdlgwngg5ac9srlybjcx9aspf6ashc7";
  };

  patches = [ ./configure-python-libs.patch ];

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

  postInstall = ''
    # Make sure PyXML modules can be found at run-time.
    for i in "$out/bin/"*
    do
      wrapProgram "$i" --prefix PYTHONPATH :      \
       "$(toPythonPath ${pyxml}):$(toPythonPath ${lxml})" ||  \
        exit 2
    done
    rm $out/share/icons/hicolor/icon-theme.cache
  '';

  NIX_LDFLAGS = "-lX11";

  meta = {
    license = "GPL";
    homepage = http://www.inkscape.org;
    longDescription = ''
      Inkscape is a feature-rich vector graphics editor that edits
      files in the W3C SVG (Scalable Vector Graphics) file format.

      If you want to import .eps files install ps2edit.
    '';
  };
}
