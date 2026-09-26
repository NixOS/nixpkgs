{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule (finalAttrs: {
  pname = "go-dnscollector";
  version = "3.1.0";

  src = fetchFromGitHub {
    owner = "dmachard";
    repo = "DNS-collector";
    tag = "v${finalAttrs.version}";
    hash = "sha256-W0fCI/1aiSbKiFQ/DwNuc2+NSGs+QwN+Gv9OUu5rLOY=";
  };

  vendorHash = "sha256-6GMoyJy9HtuGjur1VwtgP3G9CXBKiJZlK/4YNPxhIgo=";

  subPackages = [ "." ];

  meta = {
    description = "Ingesting, pipelining, and enhancing your DNS logs with usage indicators, security analysis, and additional metadata";
    homepage = "https://github.com/dmachard/DNS-collector";
    changelog = "https://github.com/dmachard/DNS-collector/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ shift ];
  };
})
