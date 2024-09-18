{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:
buildGoModule rec {
  pname = "elasticsearch_exporter";
  version = "1.7.0";

  src = fetchFromGitHub {
    owner = "prometheus-community";
    repo = "elasticsearch_exporter";
    rev = "v${version}";
    hash = "sha256-a70huy6J0Ob9LkLuCSVZqJChTo/4cPufbkq1v/QcKE4=";
  };

  vendorHash = "sha256-5uQfeDRi7EMcUCkXdbNlSe1IUpv6e5ueXtZ4C5SWAmw=";

  meta = with lib; {
    description = "Elasticsearch stats exporter for Prometheus";
    mainProgram = "elasticsearch_exporter";
    homepage = "https://github.com/prometheus-community/elasticsearch_exporter";
    license = licenses.asl20;
    maintainers = teams.deshaw.members;
  };
}
