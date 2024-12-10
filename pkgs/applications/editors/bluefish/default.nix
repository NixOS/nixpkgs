{
  lib,
  stdenv,
  fetchurl,
  wrapGAppsHook3,
  pkg-config,
  gtk,
  libxml2,
  enchant,
  gucharmap,
  python3,
  gnome,
}:

stdenv.mkDerivation rec {
  pname = "bluefish";
  version = "2.2.15";

  src = fetchurl {
    url = "mirror://sourceforge/bluefish/bluefish-${version}.tar.bz2";
    sha256 = "sha256-YUPlHGtVedWW86moXg8NhYDJ9Y+ChXWxGYgODKHZQbw=";
  };

  nativeBuildInputs = [
    pkg-config
    wrapGAppsHook3
  ];
  buildInputs = [
    gnome.adwaita-icon-theme
    gtk
    libxml2
    enchant
    gucharmap
    python3
  ];

  meta = with lib; {
    description = "A powerful editor targeted towards programmers and webdevelopers";
    homepage = "https://bluefish.openoffice.nl/";
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [ vbgl ];
    platforms = platforms.all;
    mainProgram = "bluefish";
  };
}
