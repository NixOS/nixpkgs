{
  lib,
  buildGoModule,
  fetchFromGitHub,
  nixosTests,
  nix-update-script,
}:
buildGoModule (finalAttrs: {
  pname = "cortex-metrics";
  version = "1.21.1";

  src = fetchFromGitHub {
    owner = "cortexproject";
    repo = "cortex";
    tag = "v${finalAttrs.version}";
    hash = "sha256-qi+9MLjCrlN7u4WKweKiCn58H0/gr+8TblZkNRk+7Uw=";
  };

  vendorHash = null;

  subPackages = [
    "cmd/cortex"
    "cmd/query-tee"
    "cmd/test-exporter"
    "cmd/thanosconvert"
  ];

  env.CGO_ENABLED = 0;

  tags = [
    "netgo"
    "slicelabels"
  ];

  ldflags = [
    "-s"
    "-w"
    "-X main.Version=${finalAttrs.version}"
    "-X main.Revision=unknown"
    "-X main.Branch=unknown"
  ];

  postInstall = ''
    mv $out/bin/cortex $out/bin/cortex-metrics
  '';

  passthru = {
    updateScript = nix-update-script { };
    tests = {
      inherit (nixosTests) cortex-metrics;
    };
  };

  meta = {
    description = "Horizontally scalable, highly available, multi-tenant, long-term storage for Prometheus";
    homepage = "https://github.com/cortexproject/cortex";
    changelog = "https://github.com/cortexproject/cortex/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.asl20;
    mainProgram = "cortex-metrics";
    maintainers = [ ];
  };
})
