{ lib
, stdenv
, fetchFromGitHub
, cmake
, pkg-config
, boost
, libtorrent-rasterbar
, openssl
, qt6
, zlib
}:

stdenv.mkDerivation rec {
  pname = "qbittorrent-enhanced";
  version = "5.0.2.10";

  src = fetchFromGitHub {
    owner = "c0re100";
    repo = "qBittorrent-Enhanced-Edition";
    rev = "release-${version}";
    hash = "sha256-9RCG530zWQ+qzP0Y+y69NFlBWVA8GT29dY8aC1cvq7o=";
  };

  nativeBuildInputs = [
    pkg-config
    cmake
    qt6.wrapQtAppsHook
  ];

  buildInputs = [
    openssl.dev
    boost
    zlib
    libtorrent-rasterbar
    qt6.qtbase
    qt6.qtsvg
    qt6.qttools
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
