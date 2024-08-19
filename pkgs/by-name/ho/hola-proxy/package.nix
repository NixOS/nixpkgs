{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule rec {
  pname = "hola-proxy";
  version = "1.13.3";

  src = fetchFromGitHub {
    owner = "Snawoot";
    repo = "hola-proxy";
    rev = "refs/tags/v${version}";
    hash = "sha256-T4kXwseOspXtu6jMCytCqROwQP1XjKFT2ejfAA36HUY=";
  };

  vendorHash = "sha256-1mQzeopJzzXV4cCHu30QelCIz6NivOImpiCTpGnAtzY=";

  ldflags = [
    "-s"
    "-w"
  ];

  meta = {
    description = "Standalone client for proxies of Hola VPN";
    homepage = "https://github.com/Snawoot/hola-proxy/";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ Ligthiago ];
    mainProgram = "hola-proxy";
  };
}
