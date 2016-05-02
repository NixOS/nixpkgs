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
  version = "3.3.4";

  src = fetchurl {
    url = "mirror://sourceforge/qbittorrent/${name}.tar.xz";
    sha256 = "1f4impsjck8anl39pwypsck7j6xw0dl18qd0b4xi23r45jvx9l60";
  };

  nativeBuildInputs = [ pkgconfig which qmakeHook ];

  buildInputs = [ boost libtorrentRasterbar qt5.qtbase qt5.qttools ]
    ++ optional guiSupport dbus_libs;

  dontUseQmakeConfigure = true;

  preConfigure = ''
    export QT_QMAKE="$qtOut/bin"
  '';

  configureFlags = [
    "--with-boost-libdir=${boost.lib}/lib"
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
