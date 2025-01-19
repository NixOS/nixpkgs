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
  adwaita-icon-theme,
}:

stdenv.mkDerivation rec {
  pname = "bluefish";
  version = "2.2.16";

  src = fetchurl {
    url = "mirror://sourceforge/bluefish/bluefish-${version}.tar.bz2";
    sha256 = "sha256-FOZHb87o+jJvf2Px9pPSUhlfncsWrw/jyRXEmbr13XQ=";
  };

  nativeBuildInputs = [
    pkg-config
    wrapGAppsHook3
  ];
  buildInputs = [
    adwaita-icon-theme
    gtk
    libxml2
    enchant
    gucharmap
    python3
  ];

  meta = {
    description = "Powerful editor targeted towards programmers and webdevelopers";
    homepage = "https://bluefish.openoffice.nl/";
    license = lib.licenses.gpl3Plus;
    maintainers = with lib.maintainers; [ vbgl ];
    platforms = lib.platforms.all;
    mainProgram = "bluefish";
  };
}
