{ stdenv, fetchurl, intltool, pkgconfig, gtk2 }:

stdenv.mkDerivation rec {
  version = "0.8.18.1";
  name = "leafpad-${version}";
  src = fetchurl {
    url = "https://download.savannah.gnu.org/releases/leafpad/${name}.tar.gz";
    sha256 = "0b0az2wvqgvam7w0ns1j8xp2llslm1rx6h7zcsy06a7j0yp257cm";
  };

  nativeBuildInputs = [ pkgconfig ];
  buildInputs = [ intltool gtk2 ];

  hardeningDisable = [ "format" ];

  configureFlags = [
    "--enable-chooser"
  ];

  meta = with stdenv.lib; {
    description = "A notepad clone for GTK+ 2.0";
    homepage = http://tarot.freeshell.org/leafpad;
    platforms = platforms.linux;
    maintainers = [ maintainers.flosse ];
    license = licenses.gpl3;
  };
}
