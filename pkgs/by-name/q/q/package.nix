{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule rec {
  pname = "q";
  version = "0.19.8";

  src = fetchFromGitHub {
    owner = "natesales";
    repo = "q";
    tag = "v${version}";
    hash = "sha256-kR++GyCdv/5/7E+BeZdTQTjokh2vU5sXjz0f/Ld18g0=";
  };

  vendorHash = "sha256-7OknLdkJB3ujX/DL+DVdWFK5RcoEw5R9h/KY4OfKeCw=";

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
