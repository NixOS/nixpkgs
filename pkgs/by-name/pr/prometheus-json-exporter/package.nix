{
  lib,
  buildGoModule,
  fetchFromGitHub,
  nixosTests,
}:

buildGoModule rec {
  pname = "prometheus-json-exporter";
  version = "0.8.0";

  src = fetchFromGitHub {
    owner = "prometheus-community";
    repo = "json_exporter";
    rev = "v${version}";
    sha256 = "sha256-nmpErJCp31hxjVmVGaUiuKF/ya92vs+Cqw95EOFJ0BQ=";
  };

  vendorHash = "sha256-xyRr78fkiKI9udQHqr/CBwhBts9zNTA3mhRDjGVsyZA=";

  passthru.tests = { inherit (nixosTests.prometheus-exporters) json; };

  meta = {
    description = "Prometheus exporter which scrapes remote JSON by JSONPath";
    homepage = "https://github.com/prometheus-community/json_exporter";
    license = lib.licenses.asl20;
    maintainers = [ ];
    mainProgram = "json_exporter";
  };
}
