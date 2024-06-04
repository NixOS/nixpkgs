{ lib, stdenv, fetchurl, intltool, pkg-config, gtk2 }:

stdenv.mkDerivation rec {
  version = "0.8.19";
  pname = "leafpad";
  src = fetchurl {
    url = "https://download.savannah.gnu.org/releases/leafpad/${pname}-${version}.tar.gz";
    sha256 = "sha256-B9P3EvTb0KMyUf0d7hTiGv3J+SCQ/HaMEasKxVatvpc=";
  };

  nativeBuildInputs = [ pkg-config intltool ];
  buildInputs = [ gtk2 ];

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
    mainProgram = "leafpad";
  };
}
