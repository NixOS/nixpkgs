{ fetchurl, lib, stdenv, gtk, pkg-config, libofx, intltool, wrapGAppsHook3
, libsoup_3, adwaita-icon-theme }:

stdenv.mkDerivation rec {
  pname = "homebank";
  version = "5.8.2";
  src = fetchurl {
    url = "https://www.gethomebank.org/public/sources/homebank-${version}.tar.gz";
    hash = "sha256-1CpForKKHXp6le8vVlObm22VTh2LqQlI9Qk4bwlzfLA=";
  };

  nativeBuildInputs = [ pkg-config wrapGAppsHook3 intltool ];
  buildInputs = [ gtk libofx libsoup_3 adwaita-icon-theme];

  meta = with lib; {
    description = "Free, easy, personal accounting for everyone";
    mainProgram = "homebank";
    homepage = "https://www.gethomebank.org";
    license = licenses.gpl2Plus;
    maintainers = with maintainers; [ pSub frlan ];
    platforms = platforms.linux ++ platforms.darwin;
  };
}
