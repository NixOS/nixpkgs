{
  lib,
  fetchFromGitHub,
  qbittorrent,
  guiSupport ? true,
}:

(qbittorrent.override { inherit guiSupport; }).overrideAttrs (old: rec {
  pname = "qbittorrent-enhanced" + lib.optionalString (!guiSupport) "-nox";
  version = "5.1.0.11";

  src = fetchFromGitHub {
    owner = "c0re100";
    repo = "qBittorrent-Enhanced-Edition";
    rev = "release-${version}";
    hash = "sha256-LY79Y7sG6EHGOh1hRujAOMRK3MKSAblJ+FFuGlj13iQ=";
  };

  meta = old.meta // {
    description = "Unofficial enhanced version of qBittorrent, a BitTorrent client";
    homepage = "https://github.com/c0re100/qBittorrent-Enhanced-Edition";
    changelog = "https://github.com/c0re100/qBittorrent-Enhanced-Edition/blob/release-${version}/Changelog";
    maintainers = with lib.maintainers; [ ByteSudoer ];
  };
})
