{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule (finalAttrs: {
  pname = "q";
  version = "0.19.12";

  src = fetchFromGitHub {
    owner = "natesales";
    repo = "q";
    tag = "v${finalAttrs.version}";
    hash = "sha256-0m6xcmnHh6qn2spcJxlcjdO4Fd2U0UZE/ZHMq6HXW3M=";
  };

  vendorHash = "sha256-gY3o5rkHLptrq7IEJ3AVhKY+PONJw6WC1yM3fu2ZB38=";

  ldflags = [
    "-s"
    "-w"
    "-X main.version=${finalAttrs.version}"
  ];

  doCheck = false; # tries to resolve DNS

  meta = {
    description = "Tiny and feature-rich command line DNS client with support for UDP, TCP, DoT, DoH, DoQ, and ODoH";
    homepage = "https://github.com/natesales/q";
    license = lib.licenses.gpl3Only;
    maintainers = [ lib.maintainers.das_j ];
    mainProgram = "q";
  };
})
