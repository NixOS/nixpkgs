{
  buildGoModule,
  fetchFromGitHub,
  lib,
}:

buildGoModule (finalAttrs: {
  pname = "nextdns";
  version = "1.47.2";

  src = fetchFromGitHub {
    owner = "nextdns";
    repo = "nextdns";
    rev = "v${finalAttrs.version}";
    sha256 = "sha256-AlKuC5UXQ2fRgnFnIYoa0/D7ydZTaZFfenGxiZbA3io=";
  };

  vendorHash = "sha256-ZGptjQg/LfvfAEKo1rqitNh2jME06JuryPIFuWdleZk=";

  ldflags = [
    "-s"
    "-w"
    "-X main.version=${finalAttrs.version}"
  ];

  meta = {
    description = "NextDNS DNS/53 to DoH Proxy";
    homepage = "https://nextdns.io";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ pnelson ];
    mainProgram = "nextdns";
  };
})
