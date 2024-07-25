{ lib
, stdenv
, fetchFromGitHub
, cmake
, pkg-config
, boost
, libtorrent-rasterbar
, openssl
, qt5
, zlib
}:

stdenv.mkDerivation rec {
  pname = "qbittorrent-enhanced";
  version = "4.6.5.10";

  src = fetchFromGitHub {
    owner = "c0re100";
    repo = "qBittorrent-Enhanced-Edition";
    rev = "release-${version}";
    hash = "sha256-Yy0DUTz1lWkseh9x1xnHJCI89BKqi/D7zUn/S+qC+kM=";
  };

  nativeBuildInputs = [
    pkg-config
    cmake
    qt5.wrapQtAppsHook
  ];

  buildInputs = [
    openssl.dev
    boost
    zlib
    libtorrent-rasterbar
    qt5.qtbase
    qt5.qttools
  ];

  meta = {
    description = "Unofficial enhanced version of qBittorrent, a BitTorrent client";
    homepage = "https://github.com/c0re100/qBittorrent-Enhanced-Edition";
    changelog = "https://github.com/c0re100/qBittorrent-Enhanced-Edition/blob/${src.rev}/Changelog";
    license = with lib.licenses; [ gpl2Only gpl3Only ];
    maintainers = with lib.maintainers; [ ByteSudoer ];
    mainProgram = "qBittorrent-enhanced";
    platforms = lib.platforms.linux;
  };
}
