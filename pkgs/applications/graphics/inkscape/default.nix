{ stdenv, fetchurl, pkgconfig,
  perl, perlXMLParser,
  gtk, libXft, fontconfig,
  libpng, lcms,
  zlib, popt,
  boehmgc,
  libxml2, libxslt,
  glib,
  gtkmm, glibmm, libsigcxx,
  boost,
  gettext,
  python, pyxml,
  makeWrapper
}:

stdenv.mkDerivation {
  name = "inkscape-0.45";

  src = fetchurl {
    url = mirror://sourceforge/inkscape/inkscape-0.45.1.tar.gz;
    sha256 = "1y0b9bm8chn6a2ip99dj4dhg0188yn67v571ha0x38wrlmvn4k0d";
  };

  # Work around Python misdetection and set `PYTHON_LIBS' to
  # "-L/nix/store/... -lpython2.4" instead of "/nix/store/.../libpython2.4.so".
  patches = [ ./configure-python-libs.patch ];

  propagatedBuildInputs = [
    # Python is used at run-time to execute scripts, e.g., those from
    # the "Effects" menu.
    python pyxml
  ];

  buildInputs = [
    pkgconfig
    perl perlXMLParser
    gtk libXft fontconfig
    libpng
    zlib popt
    boehmgc
    libxml2 libxslt
    glib
    gtkmm glibmm libsigcxx
    lcms
    boost
    gettext
    makeWrapper
  ];

  configureFlags = "--with-python";

  postInstall = ''
    # Make sure PyXML modules can be found at run-time.
    for i in "$out/bin/"*
    do
      # FIXME: We're assuming Python 2.4.
      wrapProgram "$i" --prefix PYTHONPATH :      \
       "${pyxml}/lib/python2.4/site-packages" ||  \
        exit 2
    done
  '';

  meta = {
    license = "GPL";
    homepage = http://www.inkscape.org;
    description = ''Inkscape is a feature-rich vector graphics editor
                    that edits files in the W3C SVG (Scalable Vector
		    Graphics) file format.'';
  };
}
