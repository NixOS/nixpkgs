{ mkDerivation, lib, stdenv, fetchFromGitHub, pkg-config
, boost, libtorrent-rasterbar, qtbase, qttools, qtsvg
, debugSupport ? false
, guiSupport ? true, dbus ? null # GUI (disable to run headless)
, webuiSupport ? true # WebUI
, trackerSearch ? true, python3 ? null
}:

assert guiSupport -> (dbus != null);
assert trackerSearch -> (python3 != null);

mkDerivation rec {
  pname = "qbittorrent" + lib.optionalString (!guiSupport) "-nox";
  version = "4.5.5";

  src = fetchFromGitHub {
    owner = "qbittorrent";
    repo = "qBittorrent";
    rev = "release-${version}";
    hash = "sha256-rWv+KGw+3385GOKK4MvoSP0CepotUZELiDVFpyDf+9k=";
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

  postInstall = lib.optionalString stdenv.isDarwin ''
    mkdir -p $out/{Applications,bin}
    cp -R src/${pname}.app $out/Applications
    makeWrapper $out/{Applications/${pname}.app/Contents/MacOS,bin}/${pname}
  '';

  meta = with lib; {
    description = "Featureful free software BitTorrent client";
    homepage    = "https://www.qbittorrent.org/";
    changelog   = "https://github.com/qbittorrent/qBittorrent/blob/release-${version}/Changelog";
    license     = licenses.gpl2Plus;
    platforms   = platforms.unix;
    maintainers = with maintainers; [ Anton-Latukha kashw2 ];
  };
}
