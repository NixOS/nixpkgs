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
  version = "2.2.17";

  src = fetchurl {
    url = "mirror://sourceforge/bluefish/bluefish-${version}.tar.bz2";
    sha256 = "sha256-Onn2Ql4Uk56hNPlsFCTjqsBb7pWQS+Q0WBiDB4p7clM=";
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

  meta = with lib; {
    description = "Powerful editor targeted towards programmers and webdevelopers";
    homepage = "https://bluefish.openoffice.nl/";
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [ vbgl ];
    platforms = platforms.all;
    mainProgram = "bluefish";
  };
}
