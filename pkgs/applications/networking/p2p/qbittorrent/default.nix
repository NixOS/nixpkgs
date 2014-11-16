{ stdenv, fetchurl, qt4, which, dbus_libs, boost, libtorrentRasterbar
, pkgconfig }:

stdenv.mkDerivation rec {
  name = "qbittorrent-3.1.11";

  src = fetchurl {
    url = "mirror://sourceforge/qbittorrent/${name}.tar.xz";
    sha256 = "0qvz8ifk01b9sw9x5yh3b5kmssx5yi026zvgvabdvfaqkvcmw43i";
  };

  buildInputs = [
    qt4 which dbus_libs boost libtorrentRasterbar pkgconfig
  ];

  configureFlags = [
    "--with-libboost-lib=${boost.lib}/lib"
    "--with-libboost-inc=${boost.dev}/include"
  ];

  # https://github.com/qbittorrent/qBittorrent/issues/1992 
  #enableParallelBuilding = true;

  meta = with stdenv.lib; {
    description = "Free Software alternative to µtorrent";
    homepage = http://www.qbittorrent.org/;
    license = licenses.gpl2;
    maintainers = with maintainers; [ viric ];
    platforms = platforms.linux;
  };
}
