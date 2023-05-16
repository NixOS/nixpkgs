{ fetchurl, lib, stdenv, gtk, pkg-config, libofx, intltool, wrapGAppsHook
, libsoup, gnome }:

stdenv.mkDerivation rec {
  pname = "homebank";
<<<<<<< HEAD
  version = "5.6.6";
  src = fetchurl {
    url = "http://homebank.free.fr/public/sources/homebank-${version}.tar.gz";
    hash = "sha256-ZW/N8YUU8r7SYY/+hqVYrqYW/KQqtuChfQJxXftl3A4=";
  };

  nativeBuildInputs = [ pkg-config wrapGAppsHook intltool ];
  buildInputs = [ gtk libofx libsoup gnome.adwaita-icon-theme];
=======
  version = "5.5.6";
  src = fetchurl {
    url = "http://homebank.free.fr/public/homebank-${version}.tar.gz";
    sha256 = "sha256-Rg6OjHLkwVIDnXqzqPXA8DxqSdrh2T6V/gLBND8vx9o=";
  };

  nativeBuildInputs = [ pkg-config wrapGAppsHook intltool ];
  buildInputs = [ gtk libofx libsoup gnome.adwaita-icon-theme ];
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  meta = with lib; {
    description = "Free, easy, personal accounting for everyone";
    homepage = "http://homebank.free.fr/";
    license = licenses.gpl2Plus;
    maintainers = with maintainers; [ pSub ];
<<<<<<< HEAD
    platforms = platforms.linux ++ platforms.darwin;
=======
    platforms = platforms.linux;
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };
}
