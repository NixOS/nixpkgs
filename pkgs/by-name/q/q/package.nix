{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule rec {
  pname = "q";
  version = "0.19.11";

  src = fetchFromGitHub {
    owner = "natesales";
    repo = "q";
    tag = "v${version}";
    hash = "sha256-8/pUkkG43y07XQVrlrVuXtbXJw5ueokOFngWK6N7qHQ=";
  };

  vendorHash = "sha256-4W0lS7qh3CCSbAtohc/1EbwdiO75tELTp1aBMyPeh/o=";

  ldflags = [
    "-s"
    "-w"
    "-X main.version=${version}"
  ];

  doCheck = false; # tries to resolve DNS

  meta = {
    description = "Tiny and feature-rich command line DNS client with support for UDP, TCP, DoT, DoH, DoQ, and ODoH";
    homepage = "https://github.com/natesales/q";
    license = lib.licenses.gpl3Only;
    maintainers = [ lib.maintainers.das_j ];
    mainProgram = "q";
  };
}
