{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule (finalAttrs: {
  pname = "go-dnscollector";
  version = "2.1.0";

  src = fetchFromGitHub {
    owner = "dmachard";
    repo = "go-dnscollector";
    tag = "v${finalAttrs.version}";
    hash = "sha256-b1fKxjdZpCuPg+lRhpYn8tjVOqQU1kyhta63G+8Pxr4=";
  };

  vendorHash = "sha256-UNp2lttwBQM9Xx6+aOQGKdOgeMBsyCHQdhCAbyvDCN4=";

  subPackages = [ "." ];

  meta = {
    description = "Ingesting, pipelining, and enhancing your DNS logs with usage indicators, security analysis, and additional metadata";
    homepage = "https://github.com/dmachard/go-dnscollector";
    changelog = "https://github.com/dmachard/DNS-collector/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ shift ];
  };
})
