{ fetchurl, stdenv, gtk, pkgconfig, libofx, intltool, wrapGAppsHook
, hicolor_icon_theme, libsoup}:

let
   download_root = "http://homebank.free.fr/public/";
   name = "homebank-5.1.1";
   lastrelease = download_root + name + ".tar.gz";
   oldrelease = download_root + "old/" + name + ".tar.gz";
in

stdenv.mkDerivation {
  inherit name;

  src = fetchurl {
    urls = [ lastrelease oldrelease ];
    sha256 = "1gd4b8fsq89w486mfrclw4r1nrgh7lxp4sncbgprbz9id7f6vlww";
  };

  buildInputs = [ pkgconfig gtk libofx intltool hicolor_icon_theme
   wrapGAppsHook libsoup ];

  meta = {
    description = "Free, easy, personal accounting for everyone";
    homepage = http://homebank.free.fr/;
    license = stdenv.lib.licenses.gpl2Plus;
    maintainers = with stdenv.lib.maintainers; [viric];
    platforms = with stdenv.lib.platforms; linux;
  };
}
