{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule rec {
  pname = "q";
  version = "0.19.10";

  src = fetchFromGitHub {
    owner = "natesales";
    repo = "q";
    tag = "v${version}";
    hash = "sha256-bP4aFoGv7VlzCXkMYzDHp3VzgA3MpqugmNE3Vyta4iM=";
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
