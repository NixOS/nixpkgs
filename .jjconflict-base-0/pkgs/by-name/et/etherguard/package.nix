{
  fetchFromGitHub,
  buildGoModule,
  lib,
}:
buildGoModule rec {
  pname = "etherguard";
  version = "0.3.5-f5";
  src = fetchFromGitHub {
    owner = "KusakabeShi";
    repo = "EtherGuard-VPN";
    rev = "v${version}";
    hash = "sha256-67ocXHf+AN3nyPt4636ZJHGRqWSjkpTiDvU5243urBw=";
  };

  vendorHash = "sha256-9+zpQ/AhprMMfC4Om64GfQLgms6eluTOB6DdnSTNOlk=";

  meta = {
    mainProgram = "EtherGuard-VPN";
    maintainers = with lib.maintainers; [ xddxdd ];
    description = "Layer 2 version of WireGuard with Floyd Warshall implementation in Go";
    homepage = "https://github.com/KusakabeShi/EtherGuard-VPN";
    license = lib.licenses.mit;
    platforms = lib.platforms.linux;
  };
}
