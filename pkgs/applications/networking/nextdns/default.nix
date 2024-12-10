{
  buildGoModule,
  fetchFromGitHub,
  lib,
}:

buildGoModule rec {
  pname = "nextdns";
  version = "1.43.3";

  src = fetchFromGitHub {
    owner = "nextdns";
    repo = "nextdns";
    rev = "v${version}";
    sha256 = "sha256-sltTvjEfUZsmXDEyN+Zyck7oqZ+Xu8xScNnitt/0eic=";
  };

  vendorHash = "sha256-U5LJF1RX0ZS0PhjQTZKXrJo89WPfSZaVbgskWcYNlJY=";

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
