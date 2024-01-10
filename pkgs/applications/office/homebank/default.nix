{ fetchurl, lib, stdenv, gtk, pkg-config, libofx, intltool, wrapGAppsHook
, libsoup_3, gnome }:

stdenv.mkDerivation rec {
  pname = "homebank";
  version = "5.7.3";
  src = fetchurl {
    url = "https://www.gethomebank.org/public/sources/homebank-${version}.tar.gz";
    hash = "sha256-ad8XKlmazWZim/mLNmnsFSy5Oni7yv3HQxYX3SXzXcU=";
  };

  nativeBuildInputs = [ pkg-config wrapGAppsHook intltool ];
  buildInputs = [ gtk libofx libsoup_3 gnome.adwaita-icon-theme];

  meta = with lib; {
    description = "Free, easy, personal accounting for everyone";
    homepage = "https://www.gethomebank.org";
    license = licenses.gpl2Plus;
    maintainers = with maintainers; [ pSub ];
    platforms = platforms.linux ++ platforms.darwin;
  };
}
