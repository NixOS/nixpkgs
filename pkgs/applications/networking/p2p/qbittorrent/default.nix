{ mkDerivation, lib, fetchFromGitHub, makeWrapper, pkg-config
, boost, libtorrent-rasterbar, qtbase, qttools, qtsvg
, debugSupport ? false
, guiSupport ? true, dbus ? null # GUI (disable to run headless)
, webuiSupport ? true # WebUI
, trackerSearch ? true, python3 ? null
}:

assert guiSupport -> (dbus != null);
assert trackerSearch -> (python3 != null);

with lib;
mkDerivation rec {
  pname = "qbittorrent";
  version = "4.3.5";

  src = fetchFromGitHub {
    owner = "qbittorrent";
    repo = "qBittorrent";
    rev = "release-${version}";
    sha256 = "1vdk42f8rxffyfydjk5cgzg5gl88ng2pynlyxw5ajh08wvkkjzgy";
  };

  enableParallelBuilding = true;

  # NOTE: 2018-05-31: CMake is working but it is not officially supported
  nativeBuildInputs = [ makeWrapper pkg-config ];

  buildInputs = [ boost libtorrent-rasterbar qtbase qttools qtsvg ]
    ++ optional guiSupport dbus # D(esktop)-Bus depends on GUI support
    ++ optional trackerSearch python3;

  # Otherwise qm_gen.pri assumes lrelease-qt5, which does not exist.
  QMAKE_LRELEASE = "lrelease";

  configureFlags = [
    "--with-boost-libdir=${boost.out}/lib"
    "--with-boost=${boost.dev}" ]
    ++ optionals (!guiSupport) [ "--disable-gui" "--enable-systemd" ] # Also place qbittorrent-nox systemd service files
    ++ optional (!webuiSupport) "--disable-webui"
    ++ optional debugSupport "--enable-debug";

  postInstall = "wrapProgram $out/bin/${
    if guiSupport
    then "qbittorrent"
    else "qbittorrent-nox"
  } --prefix PATH : ${makeBinPath [ python3 ]}";

  meta = {
    description = "Featureful free software BitTorrent client";
    homepage    = "https://www.qbittorrent.org/";
    changelog   = "https://github.com/qbittorrent/qBittorrent/blob/release-${version}/Changelog";
    license     = licenses.gpl2Plus;
    platforms   = platforms.linux;
    maintainers = with maintainers; [ Anton-Latukha ];
  };
}
