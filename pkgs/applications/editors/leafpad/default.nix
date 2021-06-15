{ lib, stdenv, fetchurl, intltool, pkg-config, gtk2 }:

stdenv.mkDerivation rec {
  version = "0.8.18.1";
  pname = "leafpad";
  src = fetchurl {
    url = "https://download.savannah.gnu.org/releases/leafpad/${pname}-${version}.tar.gz";
    sha256 = "0b0az2wvqgvam7w0ns1j8xp2llslm1rx6h7zcsy06a7j0yp257cm";
  };

  nativeBuildInputs = [ pkg-config ];
  buildInputs = [ intltool gtk2 ];

  hardeningDisable = [ "format" ];

  configureFlags = [
    "--enable-chooser"
  ];

  meta = with lib; {
    description = "A notepad clone for GTK 2.0";
    homepage = "http://tarot.freeshell.org/leafpad";
    platforms = platforms.linux;
    maintainers = [ maintainers.flosse ];
    license = licenses.gpl3;
  };
}
