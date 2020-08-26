{ stdenv, fetchurl, dee, gtk2, intltool, libdbusmenu-gtk2, libunity, pkg-config, rsync }:

stdenv.mkDerivation rec {
  version = "1.2.8";
  pname = "grsync";

  src = fetchurl {
    url = "mirror://sourceforge/grsync/grsync-${version}.tar.gz";
    sha256 = "1c86jch73cy7ig9k4shvcd3jnaxk7jppfcr8nmkz8gbylsn5zsll";
  };

  nativeBuildInputs = [
    intltool
    pkg-config
  ];

  buildInputs = [
    dee
    gtk2
    libdbusmenu-gtk2
    libunity
    rsync
  ];

  meta = with stdenv.lib; {
    description = "Grsync is used to synchronize folders, files and make backups";
    homepage = "http://www.opbyte.it/grsync/";
    license = licenses.gpl1;
    platforms = platforms.linux;
    maintainers = [ maintainers.kuznero ];
  };
}
