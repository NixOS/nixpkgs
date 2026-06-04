{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule rec {
  pname = "statsd_exporter";
  version = "0.30.0";

  src = fetchFromGitHub {
    owner = "prometheus";
    repo = "statsd_exporter";
    rev = "v${version}";
    hash = "sha256-BvX1S+PXOGVk5VmBcGypANmf5gJk1niA1knCxUAfQLY=";
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

  vendorHash = "sha256-cWASZL8pnlGyb07HZ11oMxJbcmDlX93oqXUhXOTiKP4=";

  meta = {
    description = "Receives StatsD-style metrics and exports them to Prometheus";
    mainProgram = "statsd_exporter";
    homepage = "https://github.com/prometheus/statsd_exporter";
    changelog = "https://github.com/prometheus/statsd_exporter/blob/v${version}/CHANGELOG.md";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [
      benley
    ];
  };
}
