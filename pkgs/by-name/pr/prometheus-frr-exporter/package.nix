{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

let
  version = "1.10.0";
  src = fetchFromGitHub {
    owner = "tynany";
    repo = "frr_exporter";
    rev = "v${version}";
    hash = "sha256-Q8OrFmj54Tvn283ZbFc+R/g3cJw5ypAvV+Qbf/6BsmM=";
  };
in
buildGoModule {
  pname = "prometheus-frr-exporter";
  vendorHash = "sha256-Z4miOR9gmZlYR/VAbMY6SLZJrzBEpuJbnrIJ3ObaZ/Y=";
  inherit src version;

  ldflags = [
    "-X github.com/prometheus/common/version.Version=${version}"
    "-X github.com/prometheus/common/version.Revision=${src.rev}"
    "-X github.com/prometheus/common/version.Branch=unknown"
  ];

  meta = {
    description = "Prometheus exporter for FRR version 3.0+";
    longDescription = ''
      Prometheus exporter for FRR version 3.0+ that collects metrics from the
      FRR Unix sockets and exposes them via HTTP, ready for collecting by
      Prometheus.
    '';
    homepage = "https://github.com/tynany/frr_exporter";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ javaes ];
    mainProgram = "frr_exporter";
  };
}
