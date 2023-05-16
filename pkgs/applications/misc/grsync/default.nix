{ lib, stdenv, fetchurl, dee, gtk3, intltool, libdbusmenu-gtk3, libunity, pkg-config, rsync }:

stdenv.mkDerivation rec {
<<<<<<< HEAD
  version = "1.3.1";
=======
  version = "1.3.0";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  pname = "grsync";

  src = fetchurl {
    url = "mirror://sourceforge/grsync/grsync-${version}.tar.gz";
<<<<<<< HEAD
    sha256 = "sha256-M8wOJdqmLlunCRyuo8g6jcdNxddyHEUB00nyEMSzxtM=";
=======
    sha256 = "sha256-t8fGpi4FMC2DF8OHQefXHvmrRjnuW/8mIqODsgQ6Nfw=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };

  nativeBuildInputs = [
    intltool
    pkg-config
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
    maintainers = [ maintainers.kuznero ];
  };
}
