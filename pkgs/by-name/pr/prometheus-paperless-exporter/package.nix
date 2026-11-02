{
  lib,
  buildGoModule,
  fetchFromGitHub,
  nix-update-script,
}:

buildGoModule (finalAttrs: {
  pname = "prometheus-paperless-exporter";
  version = "0.0.10";

  src = fetchFromGitHub {
    owner = "hansmi";
    repo = "prometheus-paperless-exporter";
    tag = "v${finalAttrs.version}";
    hash = "sha256-lkbys21Cg2PKD7IvkC+6ZXMJrfsN4vzCA3s3/9up7Ao=";
  };

  vendorHash = "sha256-tcDvjvh8ZwxRfTD8/rZwNanIxqN7UMFd2p6F3Yid4iM=";

  __structuredAttrs = true;
  __darwinAllowLocalNetworking = true;

  ldflags = [
    "-X github.com/prometheus/common/version.Version=${finalAttrs.version}"
    "-X github.com/prometheus/common/version.Revision=${finalAttrs.src.tag}"
    "-X github.com/prometheus/common/version.Branch=${finalAttrs.src.tag}"
  ];

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Prometheus exporter for Paperless-ngx";
    homepage = "https://github.com/hansmi/prometheus-paperless-exporter";
    changelog = "https://github.com/hansmi/prometheus-paperless-exporter/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.bsd3;
    maintainers = with lib.maintainers; [ shgew ];
    mainProgram = "prometheus-paperless-exporter";
    platforms = lib.platforms.unix;
  };
})
