{ mkDerivation, lib, fetchFromGitHub, pkg-config
, boost, libtorrent-rasterbar, qtbase, qttools, qtsvg
, debugSupport ? false
, guiSupport ? true, dbus ? null # GUI (disable to run headless)
, webuiSupport ? true # WebUI
, trackerSearch ? true, python3 ? null
}:

assert guiSupport -> (dbus != null);
assert trackerSearch -> (python3 != null);

mkDerivation rec {
  pname = "qbittorrent";
  version = "4.4.5";

  src = fetchFromGitHub {
    owner = "qbittorrent";
    repo = "qBittorrent";
    rev = "release-${version}";
    sha256 = "sha256-EgRDNOJ4szdZA5ipOuGy2R0oVdjWcuqPU3ecU3ZNK3g=";
  };

  enableParallelBuilding = true;

  # NOTE: 2018-05-31: CMake is working but it is not officially supported
  nativeBuildInputs = [ pkg-config ];

  buildInputs = [ boost libtorrent-rasterbar qtbase qttools qtsvg ]
    ++ lib.optional guiSupport dbus # D(esktop)-Bus depends on GUI support
    ++ lib.optional trackerSearch python3;

  # Otherwise qm_gen.pri assumes lrelease-qt5, which does not exist.
  QMAKE_LRELEASE = "lrelease";

  configureFlags = [
    "--with-boost-libdir=${boost.out}/lib"
    "--with-boost=${boost.dev}" ]
    ++ lib.optionals (!guiSupport) [ "--disable-gui" "--enable-systemd" ] # Also place qbittorrent-nox systemd service files
    ++ lib.optional (!webuiSupport) "--disable-webui"
    ++ lib.optional debugSupport "--enable-debug";

  qtWrapperArgs = lib.optional trackerSearch "--prefix PATH : ${lib.makeBinPath [ python3 ]}";

  meta = with lib; {
    description = "Featureful free software BitTorrent client";
    homepage    = "https://www.qbittorrent.org/";
    changelog   = "https://github.com/qbittorrent/qBittorrent/blob/release-${version}/Changelog";
    license     = licenses.gpl2Plus;
    platforms   = platforms.linux;
    maintainers = with maintainers; [ Anton-Latukha ];
  };
}
