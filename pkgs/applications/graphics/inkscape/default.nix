args: with args;

stdenv.mkDerivation rec {
  name = "inkscape-0.45.1";

  src = fetchurl {
    url = "mirror://sf/inkscape/${name}.tar.gz";
    sha256 = "1y0b9bm8chn6a2ip99dj4dhg0188yn67v571ha0x38wrlmvn4k0d";
  };

  buildInputs = [
    pkgconfig perl perlXMLParser gtk libXft fontconfig libpng zlib popt boehmgc
    libxml2 libxslt glib gtkmm glibmm libsigcxx lcms boost gettext
  ];

  meta = {
    homepage = http://www.inkscape.org;
  };
}
