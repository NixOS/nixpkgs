{ fetchurl, lib, stdenv, gtk, pkg-config, libofx, intltool, wrapGAppsHook3
, libsoup_3, gnome }:

stdenv.mkDerivation rec {
  pname = "homebank";
  version = "5.8";
  src = fetchurl {
    url = "https://www.gethomebank.org/public/sources/homebank-${version}.tar.gz";
    hash = "sha256-tgjcz4znnw++5lBoJDWtHKpRFENfM0xBpyhGf8nAACw=";
  };

  nativeBuildInputs = [ pkg-config wrapGAppsHook3 intltool ];
  buildInputs = [ gtk libofx libsoup_3 gnome.adwaita-icon-theme];

  meta = with lib; {
    description = "Free, easy, personal accounting for everyone";
    mainProgram = "homebank";
    homepage = "https://www.gethomebank.org";
    license = licenses.gpl2Plus;
    maintainers = with maintainers; [ pSub frlan ];
    platforms = platforms.linux ++ platforms.darwin;
  };
}
