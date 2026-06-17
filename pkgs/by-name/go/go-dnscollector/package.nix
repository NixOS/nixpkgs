{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule (finalAttrs: {
  pname = "go-dnscollector";
  version = "2.2.3";

  src = fetchFromGitHub {
    owner = "dmachard";
    repo = "go-dnscollector";
    tag = "v${finalAttrs.version}";
    hash = "sha256-hqSfL3R0fp7uYBGoD1Wu0ZNLq1VnOvcN0n8zzfRXTfA=";
  };

  vendorHash = "sha256-i1Ogo5zRYaEgiYMMTUjI2WiL2gABw2r31/WslXLzowI=";

  subPackages = [ "." ];

  meta = {
    description = "Ingesting, pipelining, and enhancing your DNS logs with usage indicators, security analysis, and additional metadata";
    homepage = "https://github.com/dmachard/go-dnscollector";
    changelog = "https://github.com/dmachard/DNS-collector/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ shift ];
  };
})
