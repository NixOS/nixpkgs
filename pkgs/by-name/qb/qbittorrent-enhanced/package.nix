{
  clientWhitelist ? true,
  fetchFromGitHub,
  guiSupport ? true,
  lib,
  qbittorrent,
}:

(qbittorrent.override { inherit guiSupport; }).overrideAttrs (old: rec {
  pname = "qbittorrent-enhanced" + lib.optionalString (!guiSupport) "-nox";
  version = "5.0.4.10";

  src = fetchFromGitHub {
    owner = "c0re100";
    repo = "qBittorrent-Enhanced-Edition";
    rev = "release-${version}";
    hash = "sha256-qYGDPEg4BZZgHschgFjp23EnmaBtmM+UNoC2Lympt/g=";
  };

  postUnpack = lib.optionalString clientWhitelist ''
    #Use default qBittorrent user agent for tracker whitelist
    substituteInPlace source/src/base/bittorrent/sessionimpl.cpp --replace-fail "qBittorrent Enhanced" "qBittorrent"
    substituteInPlace source/src/base/net/dnsupdater.cpp --replace-fail "qBittorrent Enhanced" "qBittorrent"
    substituteInPlace source/src/base/version.h.in --replace-fail "QBT_VERSION_BUILD 10" "QBT_VERSION_BUILD 0"
  '';

  meta = old.meta // {
    description = "Unofficial enhanced version of qBittorrent, a BitTorrent client";
    homepage = "https://github.com/c0re100/qBittorrent-Enhanced-Edition";
    changelog = "https://github.com/c0re100/qBittorrent-Enhanced-Edition/blob/release-${version}/Changelog";
    maintainers = with lib.maintainers; [ ByteSudoer ];
  };
})
