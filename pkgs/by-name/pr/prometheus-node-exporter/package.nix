{
  lib,
  buildGoModule,
  fetchFromGitHub,
  nixosTests,
  versionCheckHook,
}:

buildGoModule (finalAttrs: {
  pname = "node_exporter";
  version = "1.10.2";

  src = fetchFromGitHub {
    owner = "prometheus";
    repo = "node_exporter";
    tag = "${finalAttrs.version}";
    hash = "sha256-UaybbRmcvifXNwTNXg7mIYN9JnonSxwG62KfvU5auIE=";
  };

  vendorHash = "sha256-zQn3Hn40zZT3ZLiYQc/68i9t791eisBSiB6Re24/Ncg=";

  # FIXME: tests fail due to read-only nix store
  doCheck = false;

  excludedPackages = [ "docs/node-mixin" ];

  ldflags = [
    "-s"
    "-w"
    "-X github.com/prometheus/common/version.Version=${finalAttrs.version}"
    "-X github.com/prometheus/common/version.Revision=unknown"
    "-X github.com/prometheus/common/version.Branch=unknown"
    "-X github.com/prometheus/common/version.BuildUser=nix@nixpkgs"
    "-X github.com/prometheus/common/version.BuildDate=unknown"
  ];

  passthru.tests = { inherit (nixosTests.prometheus-exporters) node; };

  nativeInstallCheckInputs = [
    versionCheckHook
  ];
  doInstallCheck = true;

  meta = {
    description = "Prometheus exporter for machine metrics";
    mainProgram = "node_exporter";
    homepage = "https://github.com/prometheus/node_exporter";
    changelog = "https://github.com/prometheus/node_exporter/blob/v${finalAttrs.version}/CHANGELOG.md";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [
      benley
      fpletz
      globin
      Frostman
    ];
  };
})
