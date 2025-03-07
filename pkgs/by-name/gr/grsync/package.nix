{
  lib,
  stdenv,
  fetchurl,
  dee,
  gtk3,
  intltool,
  libdbusmenu-gtk3,
  libunity,
  pkg-config,
  rsync,
  wrapGAppsHook3,
}:

stdenv.mkDerivation rec {
  version = "1.3.1";
  pname = "grsync";

  src = fetchurl {
    url = "mirror://sourceforge/grsync/grsync-${version}.tar.gz";
    sha256 = "sha256-M8wOJdqmLlunCRyuo8g6jcdNxddyHEUB00nyEMSzxtM=";
  };

  nativeBuildInputs = [
    intltool
    pkg-config
    wrapGAppsHook3
  ];

  buildInputs = [
    dee
    gtk3
    libdbusmenu-gtk3
    libunity
    rsync
  ];

  meta = with lib; {
    description = "Synchronize folders, files and make backups";
    homepage = "http://www.opbyte.it/grsync/";
    license = licenses.gpl2Only;
    platforms = platforms.linux;
    mainProgram = "grsync";
    maintainers = [ maintainers.kuznero ];
  };
}
