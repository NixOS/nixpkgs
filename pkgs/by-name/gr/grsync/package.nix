{
  lib,
  stdenv,
  fetchurl,
  gtk3,
  intltool,
  pkg-config,
  wrapGAppsHook3,
}:

stdenv.mkDerivation (finalAttrs: {
  version = "1.3.1";
  pname = "grsync";

  src = fetchurl {
    url = "mirror://sourceforge/grsync/grsync-${finalAttrs.version}.tar.gz";
    sha256 = "sha256-M8wOJdqmLlunCRyuo8g6jcdNxddyHEUB00nyEMSzxtM=";
  };

  nativeBuildInputs = [
    intltool
    pkg-config
    wrapGAppsHook3
  ];

  buildInputs = [
    gtk3
  ];

  meta = {
    description = "Synchronize folders, files and make backups";
    homepage = "http://www.opbyte.it/grsync/";
    license = lib.licenses.gpl2Only;
    platforms = lib.platforms.linux;
    mainProgram = "grsync";
    maintainers = [ lib.maintainers.kuznero ];
  };
})
