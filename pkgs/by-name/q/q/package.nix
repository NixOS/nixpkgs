{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule rec {
  pname = "q";
  version = "0.19.9";

  src = fetchFromGitHub {
    owner = "natesales";
    repo = "q";
    tag = "v${version}";
    hash = "sha256-QYSy2RaEWNkitehsmcfGYTCvpHtu1aVRuwBVNMjOHZ0=";
  };

  vendorHash = "sha256-g5ZrzkPqkvoz0Q0ERXYlNk7lDf+6V27yKa+5NLVZHCI=";

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
