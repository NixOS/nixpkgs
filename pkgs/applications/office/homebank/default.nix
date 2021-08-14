{ fetchurl, lib, stdenv, gtk, pkg-config, libofx, intltool, wrapGAppsHook
, libsoup, gnome }:

stdenv.mkDerivation rec {
  name = "homebank-5.5.3";
  src = fetchurl {
    url = "http://homebank.free.fr/public/${name}.tar.gz";
    sha256 = "sha256-BzYHkYqWEAh3kfNvWecNEmH+6OThFGpc/VhxodLZEJM=";
  };

  nativeBuildInputs = [ pkg-config wrapGAppsHook ];
  buildInputs = [ gtk libofx intltool libsoup
    gnome.adwaita-icon-theme ];

  meta = with lib; {
    description = "Free, easy, personal accounting for everyone";
    homepage = "http://homebank.free.fr/";
    license = licenses.gpl2Plus;
    maintainers = with maintainers; [ pSub ];
    platforms = platforms.linux;
  };
}
