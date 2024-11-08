{ buildGoModule, fetchFromGitHub, lib }:

buildGoModule rec {
  pname = "nextdns";
  version = "1.43.5";

  src = fetchFromGitHub {
    owner = "nextdns";
    repo = "nextdns";
    rev = "v${version}";
    sha256 = "sha256-XQ3dFv+JZ8x/SpaPhrauO8EfcpGrm9vbmQ7LLY1dQuE=";
  };

  vendorHash = "sha256-U5LJF1RX0ZS0PhjQTZKXrJo89WPfSZaVbgskWcYNlJY=";

  ldflags = [ "-s" "-w" "-X main.version=${version}" ];

  meta = with lib; {
    description = "NextDNS DNS/53 to DoH Proxy";
    homepage = "https://nextdns.io";
    license = licenses.mit;
    maintainers = with maintainers; [ pnelson ];
    mainProgram = "nextdns";
  };
}
