{ stdenv, fetchurl, qt4, which, dbus_libs, boost, libtorrentRasterbar
, pkgconfig }:

stdenv.mkDerivation rec {
  name = "qbittorrent-3.1.2";

  src = fetchurl {
    url = "mirror://sourceforge/qbittorrent/${name}.tar.xz";
    sha256 = "1viia11qixp1qqxcyiw1x4if63cfyqk4rscpzp1vnhnzm06irv7y";
  };

  buildInputs = [ qt4 which dbus_libs boost libtorrentRasterbar
    pkgconfig ];

  configureFlags = "--with-libboost-inc=${boost}/include "
    + "--with-libboost-lib=${boost}/lib";

  enableParallelBuilding = true;

  meta = {
    description = "Free Software alternative to µtorrent";
    homepage = http://www.qbittorrent.org/;
    maintainers = with stdenv.lib.maintainers; [ viric ];
  };
}
