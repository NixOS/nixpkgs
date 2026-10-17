{
  lib,
  fetchFromGitHub,
  qbittorrent,
  guiSupport ? true,
}:

(qbittorrent.override { inherit guiSupport; }).overrideAttrs (old: rec {
  pname = "qbittorrent-enhanced" + lib.optionalString (!guiSupport) "-nox";
  version = "5.2.3.10";

  src = fetchFromGitHub {
    owner = "c0re100";
    repo = "qBittorrent-Enhanced-Edition";
    rev = "release-${version}";
    hash = "sha256-frAmiYQekEzIgWeSqHVAlTY5u6j7eH8Nx8MaqHjZU9E=";
  };

  meta = old.meta // {
    description = "Unofficial enhanced version of qBittorrent, a BitTorrent client";
    homepage = "https://github.com/c0re100/qBittorrent-Enhanced-Edition";
    changelog = "https://github.com/c0re100/qBittorrent-Enhanced-Edition/blob/release-${version}/Changelog";
    maintainers = with lib.maintainers; [ ByteSudoer ];
  };
})
