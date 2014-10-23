{ stdenv, fetchurl, intltool, pkgconfig, gtk }:

stdenv.mkDerivation rec {
  version = "0.8.18.1";
  name = "leafpad-${version}";
  src = fetchurl {
    url = "http://download.savannah.gnu.org/releases/leafpad/${name}.tar.gz";
    sha256 = "0b0az2wvqgvam7w0ns1j8xp2llslm1rx6h7zcsy06a7j0yp257cm";
  };

  buildInputs = [ intltool pkgconfig gtk ];

  configureFlags = [
    "--enable-chooser"
  ];

  meta = {
    description = "A notepad clone for GTK+ 2.0";
    homepage = http://tarot.freeshell.org/leafpad;
    maintainers = [ stdenv.lib.maintainers.flosse ];
    license = stdenv.lib.licenses.gpl3;
  };
}
