{ stdenv, fetchurl, pkgconfig, which
, boost, libtorrentRasterbar, qtbase, qttools
, debugSupport ? false # Debugging
, guiSupport ? true, dbus_libs ? null # GUI (disable to run headless)
, webuiSupport ? true # WebUI
}:

assert guiSupport -> (dbus_libs != null);
with stdenv.lib;

stdenv.mkDerivation rec {
  name = "qbittorrent-${version}";
  version = "3.3.16";

  src = fetchurl {
    url = "mirror://sourceforge/qbittorrent/${name}.tar.xz";
    sha256 = "0mxyn2pajvb55bhcaz55v64p2xzy15p0yy174s62b5y3f8cac27a";
  };

  nativeBuildInputs = [ pkgconfig which ];

  buildInputs = [ boost libtorrentRasterbar qtbase qttools ]
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

  enableParallelBuilding = true;

  meta = {
    description = "Free Software alternative to µtorrent";
    homepage    = http://www.qbittorrent.org/;
    license     = licenses.gpl2;
    platforms   = platforms.linux;
    maintainers = with maintainers; [ viric ];
  };
}
