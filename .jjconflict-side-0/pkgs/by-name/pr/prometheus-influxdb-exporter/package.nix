{
  lib,
  buildGoModule,
  fetchFromGitHub,
  nixosTests,
}:

buildGoModule rec {
  pname = "influxdb_exporter";
  version = "0.12.1";
  rev = "v${version}";

  src = fetchFromGitHub {
    inherit rev;
    owner = "prometheus";
    repo = "influxdb_exporter";
    hash = "sha256-qsZZoBXhh6lfYqh2uuIyOKGyL8u8IK8Gqgmm7cXzQdw=";
  };

  vendorHash = "sha256-NhodCQVFa/5jxhfdFRe2vxuw8dlSKipfxbzD6NF/Q5w=";

  ldflags = [
    "-s"
    "-w"
    "-X github.com/prometheus/common/version.Version=${version}"
    "-X github.com/prometheus/common/version.Revision=${rev}"
    "-X github.com/prometheus/common/version.Branch=unknown"
    "-X github.com/prometheus/common/version.BuildUser=nix@nixpkgs"
    "-X github.com/prometheus/common/version.BuildDate=unknown"
  ];

  passthru.tests = { inherit (nixosTests.prometheus-exporters) influxdb; };

  meta = {
    description = "Prometheus exporter that accepts InfluxDB metrics";
    mainProgram = "influxdb_exporter";
    homepage = "https://github.com/prometheus/influxdb_exporter";
    changelog = "https://github.com/prometheus/influxdb_exporter/blob/v${version}/CHANGELOG.md";
    license = lib.licenses.asl20;
    maintainers = [ ];
  };
}
