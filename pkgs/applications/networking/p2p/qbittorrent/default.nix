{ stdenv, fetchurl, qt4, which, dbus_libs, boost, libtorrentRasterbar
, pkgconfig }:

stdenv.mkDerivation rec {
  name = "qbittorrent-3.1.10";

  src = fetchurl {
    url = "mirror://sourceforge/qbittorrent/${name}.tar.xz";
    sha256 = "0xhqli191r5v9b5x6wj1wsjlj6svf6ldgzl7jza39q3ipr5c2pg6";
  };

  buildInputs = [ qt4 which dbus_libs boost libtorrentRasterbar
    pkgconfig ];

  configureFlags = "--with-libboost-inc=${boost}/include "
    + "--with-libboost-lib=${boost}/lib";

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
