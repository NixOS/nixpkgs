{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule (finalAttrs: {
  pname = "go-dnscollector";
  version = "3.2.0";

  src = fetchFromGitHub {
    owner = "dmachard";
    repo = "DNS-collector";
    tag = "v${finalAttrs.version}";
    hash = "sha256-OM+qaXXySNmA8cn47UNcfjBL8E5dpaA/7Dw5SwOodQA=";
  };

  vendorHash = "sha256-JINwqSvvt1gRCXeWSnEedvmLVgbgUx3OxC2XBvPIKpg=";

  subPackages = [ "." ];

  meta = {
    description = "Ingesting, pipelining, and enhancing your DNS logs with usage indicators, security analysis, and additional metadata";
    homepage = "https://github.com/dmachard/DNS-collector";
    changelog = "https://github.com/dmachard/DNS-collector/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ shift ];
  };
})
