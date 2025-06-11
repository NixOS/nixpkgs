{
  lib,
  buildGoModule,
  fetchFromGitHub,
  nixosTests,
}:

buildGoModule rec {
  pname = "node_exporter";
  version = "1.9.1";
  rev = "v${version}";

  src = fetchFromGitHub {
    inherit rev;
    owner = "prometheus";
    repo = "node_exporter";
    hash = "sha256-il0wf00pUSHUrqz0Y1lr++yywlhr+Ww2pGKBeGAEnPc=";
  };

  vendorHash = "sha256-ujW5dH3ItIaML+LlaTXT0BK/T1ZGZq/cKnLOqNPBhWc=";

  # FIXME: tests fail due to read-only nix store
  doCheck = false;

  excludedPackages = [ "docs/node-mixin" ];

  ldflags = [
    "-s"
    "-w"
    "-X github.com/prometheus/common/version.Version=${version}"
    "-X github.com/prometheus/common/version.Revision=${rev}"
    "-X github.com/prometheus/common/version.Branch=unknown"
    "-X github.com/prometheus/common/version.BuildUser=nix@nixpkgs"
    "-X github.com/prometheus/common/version.BuildDate=unknown"
  ];

  passthru.tests = { inherit (nixosTests.prometheus-exporters) node; };

  meta = {
    description = "Prometheus exporter for machine metrics";
    mainProgram = "node_exporter";
    homepage = "https://github.com/prometheus/node_exporter";
    changelog = "https://github.com/prometheus/node_exporter/blob/v${version}/CHANGELOG.md";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [
      benley
      fpletz
      globin
      Frostman
    ];
  };
}
