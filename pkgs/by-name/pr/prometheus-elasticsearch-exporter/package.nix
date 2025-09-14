{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:
buildGoModule rec {
  pname = "elasticsearch_exporter";
  version = "1.9.0";

  src = fetchFromGitHub {
    owner = "prometheus-community";
    repo = "elasticsearch_exporter";
    rev = "v${version}";
    hash = "sha256-v6Fi5O/87jhFI1h6qWyWb61X+dTjcqS3Fi9/MPQSr8Y=";
  };

  vendorHash = "sha256-NAaVz5AqhfaEiWqBAeQZVWwjMIwX9jEw0oycXq7uLNw=";

  meta = {
    description = "Elasticsearch stats exporter for Prometheus";
    mainProgram = "elasticsearch_exporter";
    homepage = "https://github.com/prometheus-community/elasticsearch_exporter";
    license = lib.licenses.asl20;
    teams = [ lib.teams.deshaw ];
  };
}
