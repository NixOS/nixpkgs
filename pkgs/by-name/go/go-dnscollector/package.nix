{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule (finalAttrs: {
  pname = "go-dnscollector";
  version = "3.2.2";

  src = fetchFromGitHub {
    owner = "dmachard";
    repo = "DNS-collector";
    tag = "v${finalAttrs.version}";
    hash = "sha256-HW81WbDKNWj0cWBJel5Fu8O23Gj+2pq2ownMILk5Xoc=";
  };

  vendorHash = "sha256-Q0TltguyGccv2VnQLsjKA4i+DoIFvY+pWDZFiCN1CNM=";

  subPackages = [ "." ];

  meta = {
    description = "Ingesting, pipelining, and enhancing your DNS logs with usage indicators, security analysis, and additional metadata";
    homepage = "https://github.com/dmachard/DNS-collector";
    changelog = "https://github.com/dmachard/DNS-collector/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ shift ];
  };
})
