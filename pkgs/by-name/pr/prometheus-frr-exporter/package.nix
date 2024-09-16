{ lib, buildGoModule, fetchFromGitHub }:

let
  version = "1.3.0";
  src = fetchFromGitHub {
    owner = "tynany";
    repo = "frr_exporter";
    rev = "v${version}";
    hash = "sha256-6a58COPlV6xyy/EAJmt+lXH23ULJY5ysMM6+3VDiTmE=";
  };
in
buildGoModule {
  pname = "prometheus-frr-exporter";
  vendorHash = "sha256-AvJzt9+81WDFXU0IOo9nqT/mEYixuhBIJfBx395Wsdo=";
  inherit src version;

  ldflags = [
    "-X github.com/prometheus/common/version.Version=${version}"
    "-X github.com/prometheus/common/version.Revision=${src.rev}"
    "-X github.com/prometheus/common/version.Branch=unknown"
  ];

  meta = with lib; {
    description = "Prometheus exporter for FRR version 3.0+";
    longDescription = ''
      Prometheus exporter for FRR version 3.0+ that collects metrics from the
      FRR Unix sockets and exposes them via HTTP, ready for collecting by
      Prometheus.
    '';
    homepage = "https://github.com/tynany/frr_exporter";
    license = licenses.mit;
    maintainers = with maintainers; [ javaes ];
    mainProgram = "frr_exporter";
  };
}
