{ stdenv, fetchurl, gtk, libnotify, unzip, glib, pkgconfig }:

stdenv.mkDerivation rec {

  name = "cbatticon-${version}";
  version = "1.4.2";

  src = fetchurl {
    url = "https://github.com/valr/cbatticon/archive/${version}.zip";
    sha256 = "1jkaar987ayydgghl8s8f1yy41mcmhqvgw897jv4y8yliskn0604";
  };

  makeFlags = "PREFIX=$(out)";

  buildInputs =  [ gtk libnotify unzip glib pkgconfig ];

  meta = with stdenv.lib; {
    description = "A lightweight and fast battery icon that sits in your system tray";
    homepage = https://github.com/valr/cbatticon;
    license = licenses.gpl2;
    maintainers = [ maintainers.iElectric ];
    platforms = platforms.linux;
  };
}
