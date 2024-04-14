{ fetchurl, lib, stdenv, gtk, pkg-config, libofx, intltool, wrapGAppsHook
, libsoup_3, gnome }:

stdenv.mkDerivation rec {
  pname = "homebank";
  version = "5.7.4";
  src = fetchurl {
    url = "https://www.gethomebank.org/public/sources/homebank-${version}.tar.gz";
    hash = "sha256-Qs5xRsh16gyjyTORtqm/RxTbRiHGP0oJTcxviYW7VOQ=";
  };

  nativeBuildInputs = [ pkg-config wrapGAppsHook intltool ];
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
