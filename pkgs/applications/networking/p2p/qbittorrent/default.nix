{ stdenv, fetchurl, pkgconfig, which
, boost, libtorrentRasterbar, qt4
, debugSupport ? false # Debugging
, guiSupport ? true, dbus_libs ? null # GUI (disable to run headless)
, webuiSupport ? true # WebUI
}:

assert guiSupport -> (dbus_libs != null);

with stdenv.lib;
stdenv.mkDerivation rec {
  name = "qbittorrent-${version}";
  version = "3.2.3";

  src = fetchurl {
    url = "mirror://sourceforge/qbittorrent/${name}.tar.xz";
    sha256 = "05590ak4nnqkah8dy71cxf7mqv6phw0ih1719dm761mxf8vrz9w6";
  };

  nativeBuildInputs = [ pkgconfig which ];

  buildInputs = [ boost libtorrentRasterbar qt4 ]
    ++ optional guiSupport dbus_libs;

  configureFlags = [
    "--with-boost-libdir=${boost.lib}/lib"
    "--with-boost=${boost.dev}"
    (if guiSupport then "" else "--disable-gui")
    (if webuiSupport then "" else "--disable-webui")
  ] ++ optional debugSupport "--enable-debug";

  # https://github.com/qbittorrent/qBittorrent/issues/1992 
  enableParallelBuilding = false;

  meta = {
    description = "Free Software alternative to µtorrent";
    homepage    = http://www.qbittorrent.org/;
    license     = licenses.gpl2;
    maintainers = with maintainers; [ viric ];
    platforms   = platforms.linux;
  };
}
