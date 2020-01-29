{ mkDerivation, lib, fetchFromGitHub, pkgconfig
, boost, libtorrentRasterbar, qtbase, qttools, qtsvg
, debugSupport ? false # Debugging
, guiSupport ? true, dbus ? null # GUI (disable to run headless)
, webuiSupport ? true # WebUI
}:

assert guiSupport -> (dbus != null);
with lib;

mkDerivation rec {
  pname = "qbittorrent";
  version = "4.2.1";

  src = fetchFromGitHub {
    owner = "qbittorrent";
    repo = "qbittorrent";
    rev = "release-${version}";
    sha256 = "0bz4l7awkx4qf3gh9c8gj8fab989439zj8qy4x9r36wxdjg5cxil";
  };

  # NOTE: 2018-05-31: CMake is working but it is not officially supported
  nativeBuildInputs = [ pkgconfig ];

  buildInputs = [ boost libtorrentRasterbar qtbase qttools qtsvg ]
    ++ optional guiSupport dbus; # D(esktop)-Bus depends on GUI support

  # Otherwise qm_gen.pri assumes lrelease-qt5, which does not exist.
  QMAKE_LRELEASE = "lrelease";

  configureFlags = [
    "--with-boost-libdir=${boost.out}/lib"
    "--with-boost=${boost.dev}" ]
    ++ optionals (!guiSupport) [ "--disable-gui" "--enable-systemd" ] # Also place qbittorrent-nox systemd service files
    ++ optional (!webuiSupport) "--disable-webui"
    ++ optional debugSupport "--enable-debug";

  enableParallelBuilding = true;

  meta = {
    description = "Featureful free software BitTorrent client";
    homepage    = https://www.qbittorrent.org/;
    license     = licenses.gpl2;
    platforms   = platforms.linux;
    maintainers = with maintainers; [ Anton-Latukha ];
  };
}
