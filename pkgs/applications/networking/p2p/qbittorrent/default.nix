{ mkDerivation, lib, fetchFromGitHub, pkgconfig
, boost, libtorrentRasterbar, qtbase, qttools, qtsvg
, debugSupport ? false
, guiSupport ? true, dbus ? null # GUI OR headless
, webuiSupport ? true # WebUI
}:

assert guiSupport -> (dbus != null);

with lib;
mkDerivation rec {
  pname = "qbittorrent";
  version = "4.3.1";

  src = fetchFromGitHub {
    owner = "qbittorrent";
    repo = "qbittorrent";
    rev = "release-${version}";
    sha256 = "17ih00q7idrpl3b2vgh4smva6lazs5jw06pblriscn1lrwdvrc38";
  };

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
    homepage    = "https://www.qbittorrent.org/";
    license     = licenses.gpl2;
    platforms   = platforms.linux;
    maintainers = with maintainers; [ Anton-Latukha ];
  };
}
