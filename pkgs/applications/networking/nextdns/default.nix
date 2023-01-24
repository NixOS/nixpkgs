{ buildGoModule, fetchFromGitHub, lib }:

buildGoModule rec {
  pname = "nextdns";
  version = "1.38.0";

  src = fetchFromGitHub {
    owner = "nextdns";
    repo = "nextdns";
    rev = "v${version}";
    sha256 = "sha256-dJ/3MBEsA8M4pfE+GPT/bNnK3n4fL3Hwk0umgMTJAfY=";
  };

  vendorSha256 = "sha256-pCta8FzGVpl9fvnnjQ7/e2x/HolXAuxnz0vwKejGk98=";

  ldflags = [ "-s" "-w" "-X main.version=${version}" ];

  meta = with lib; {
    description = "NextDNS DNS/53 to DoH Proxy";
    homepage = "https://nextdns.io";
    license = licenses.mit;
    maintainers = with maintainers; [ pnelson ];
  };
}
