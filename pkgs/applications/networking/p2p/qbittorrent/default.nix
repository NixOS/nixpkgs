{ stdenv, fetchurl, pkgconfig, which
, boost, libtorrentRasterbar, qmakeHook, qt5
, debugSupport ? false # Debugging
, guiSupport ? true, dbus_libs ? null # GUI (disable to run headless)
, webuiSupport ? true # WebUI
}:

assert guiSupport -> (dbus_libs != null);

with stdenv.lib;
stdenv.mkDerivation rec {
  name = "qbittorrent-${version}";
  version = "3.3.7";

  src = fetchurl {
    url = "mirror://sourceforge/qbittorrent/${name}.tar.xz";
    sha256 = "0h2ccqmjnm0x0qjvd0vz5hk7dy9qbqhiqvxywqjhip7sj1585p3j";
  };

  nativeBuildInputs = [ pkgconfig which ];

  buildInputs = [ boost libtorrentRasterbar qt5.qtbase qt5.qttools ]
    ++ optional guiSupport dbus_libs;

  preConfigure = ''
    export QT_QMAKE=$(dirname "$QMAKE")
  '';

  configureFlags = [
    "--with-boost-libdir=${boost.out}/lib"
    "--with-boost=${boost.dev}"
    (if guiSupport then "" else "--disable-gui")
    (if webuiSupport then "" else "--disable-webui")
  ] ++ optional debugSupport "--enable-debug";

  # The lrelease binary is named lrelease instead of lrelease-qt4
  patches = [ ./fix-lrelease.patch];

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
