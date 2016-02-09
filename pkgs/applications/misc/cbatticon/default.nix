{ stdenv, fetchzip, gtk, libnotify, unzip, glib, pkgconfig }:

stdenv.mkDerivation rec {

  name = "cbatticon-${version}";
  version = "1.4.2";

  src = fetchzip {
    url = "https://github.com/valr/cbatticon/archive/${version}.zip";
    sha256 = "0ixkxvlrn84b8nh75c9s2gvxnycis89mf047iz8j38814979di5l";
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
