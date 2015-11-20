{ fetchurl, stdenv, gtk, pkgconfig, libofx, intltool, wrapGAppsHook
, hicolor_icon_theme}:

let
   download_root = "http://homebank.free.fr/public/";
   name = "homebank-5.0.6";
   lastrelease = download_root + name + ".tar.gz";
   oldrelease = download_root + "old/" + name + ".tar.gz";
in

stdenv.mkDerivation {
  inherit name;

  src = fetchurl {
    urls = [ lastrelease oldrelease ];
    sha256 = "1r1rn8lgnqnlwkspx230gly5f4i90ij0a3ddrvw51kdc41xfylja";
  };

  buildInputs = [ pkgconfig gtk libofx intltool hicolor_icon_theme wrapGAppsHook ];

  meta = {
    description = "Free, easy, personal accounting for everyone";
    homepage = http://homebank.free.fr/;
    license = stdenv.lib.licenses.gpl2Plus;
    maintainers = with stdenv.lib.maintainers; [viric];
    platforms = with stdenv.lib.platforms; linux;
  };
}
