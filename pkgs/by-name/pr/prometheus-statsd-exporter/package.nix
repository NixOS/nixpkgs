{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule rec {
  pname = "statsd_exporter";
  version = "0.29.0";

  src = fetchFromGitHub {
    owner = "prometheus";
    repo = "statsd_exporter";
    rev = "v${version}";
    hash = "sha256-zsKSvCJXj8SoEGYUCruvHlSunA2e1g4pZ7Pb1FNfVGM=";
  };

  ldflags =
    let
      t = "github.com/prometheus/common/version";
    in
    [
      "-s"
      "-w"
      "-X ${t}.Version=${version}"
      "-X ${t}.Revision=unknown"
      "-X ${t}.Branch=unknown"
      "-X ${t}.BuildUser=nix@nixpkgs"
      "-X ${t}.BuildDate=unknown"
    ];

  vendorHash = "sha256-mguXYe5CzNgryYJs6C6tJwm9FEM5bBbWbjfSogiQBmE=";

  meta = {
    description = "Receives StatsD-style metrics and exports them to Prometheus";
    mainProgram = "statsd_exporter";
    homepage = "https://github.com/prometheus/statsd_exporter";
    changelog = "https://github.com/prometheus/statsd_exporter/blob/v${version}/CHANGELOG.md";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [
      benley
      ivan
    ];
  };
}
