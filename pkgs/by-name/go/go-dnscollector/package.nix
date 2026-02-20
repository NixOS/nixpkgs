{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule (finalAttrs: {
  pname = "go-dnscollector";
  version = "2.0.0";

  src = fetchFromGitHub {
    owner = "dmachard";
    repo = "go-dnscollector";
    tag = "v${finalAttrs.version}";
    hash = "sha256-d6FFxVGolXfZF4Ulklxg8u26DdV9yHeDUf2IEEryELw=";
  };

  vendorHash = "sha256-4gk7LwRDrTiMCrR6JJpdSvCmNa7wQ5Hk06OGd6/SACc=";

  subPackages = [ "." ];

  meta = {
    description = "Ingesting, pipelining, and enhancing your DNS logs with usage indicators, security analysis, and additional metadata";
    homepage = "https://github.com/dmachard/go-dnscollector";
    changelog = "https://github.com/dmachard/DNS-collector/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ shift ];
  };
})
