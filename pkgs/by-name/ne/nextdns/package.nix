{
  buildGoModule,
  fetchFromGitHub,
  lib,
}:

buildGoModule rec {
  pname = "nextdns";
  version = "1.44.3";

  src = fetchFromGitHub {
    owner = "nextdns";
    repo = "nextdns";
    rev = "v${version}";
    sha256 = "sha256-fSYnR8yfgfOx8E9gGq82xAsvrMdujcwYq/qY/NF8LcM=";
  };

  vendorHash = "sha256-DKYWuCnpoJXJHBd6G9DFFzAPbekO+vaCPuBc4UTuxHg=";

  ldflags = [
    "-s"
    "-w"
    "-X main.version=${version}"
  ];

  meta = with lib; {
    description = "NextDNS DNS/53 to DoH Proxy";
    homepage = "https://nextdns.io";
    license = licenses.mit;
    maintainers = with maintainers; [ pnelson ];
    mainProgram = "nextdns";
  };
}
