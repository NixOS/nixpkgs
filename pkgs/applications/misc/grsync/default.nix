{ stdenv, fetchurl, dee, gtk2, intltool, libdbusmenu-gtk2, libunity, pkg-config, rsync }:

stdenv.mkDerivation rec {
  version = "1.2.6";
  pname = "grsync";

  src = fetchurl {
    url = "mirror://sourceforge/grsync/grsync-${version}.tar.gz";
    sha256 = "06ani65d58p8r3jvxjwpwyqrr07ya3icdqc243nxcrv7bvmarmb6";
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
