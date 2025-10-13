{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule rec {
  pname = "shadowsocks-v2ray-plugin";
  version = "1.3.2-unstable-2025-09-05";

  src = fetchFromGitHub {
    owner = "shadowsocks";
    repo = "v2ray-plugin";
    rev = "e9af1cdd2549d528deb20a4ab8d61c5fbe51f306";
    hash = "sha256-VkyK+Ee+RJkBixHiduFP2ET18fDNXuOf8x3h1LN9pbY=";
  };

  vendorHash = "sha256-FSYv2jC0NU21GtqRkPHjxPcdmXbiIiOM1HsL8x44gZw=";

  meta = {
    description = "Yet another SIP003 plugin for shadowsocks, based on v2ray";
    homepage = "https://github.com/shadowsocks/v2ray-plugin/";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [
      ahrzb
      neverbehave
    ];
    mainProgram = "v2ray-plugin";
  };
}
