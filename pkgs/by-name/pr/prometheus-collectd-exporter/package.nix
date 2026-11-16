{
  lib,
  buildGoModule,
  fetchFromGitHub,
  nixosTests,
}:

buildGoModule rec {
  pname = "collectd-exporter";
  version = "0.7.1";

  src = fetchFromGitHub {
    owner = "prometheus";
    repo = "collectd_exporter";
    rev = "v${version}";
    sha256 = "sha256-cKwyEWtnyXah5pKSY16Omba0MkkP/76xpfe43KAYrbc=";
  };

  vendorHash = "sha256-QGN8Ke761fTi2GzwdicMPWUIJNgBrEje2ifdJ5FymF4=";

  ldflags = [
    "-s"
    "-w"
  ];

  passthru.tests = { inherit (nixosTests.prometheus-exporters) collectd; };

  meta = {
    description = "Relay server for exporting metrics from collectd to Prometheus";
    mainProgram = "collectd_exporter";
    homepage = "https://github.com/prometheus/collectd_exporter";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ benley ];
  };
}
