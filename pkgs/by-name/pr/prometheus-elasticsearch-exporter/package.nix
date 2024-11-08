{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:
buildGoModule rec {
  pname = "elasticsearch_exporter";
  version = "1.8.0";

  src = fetchFromGitHub {
    owner = "prometheus-community";
    repo = "elasticsearch_exporter";
    rev = "v${version}";
    hash = "sha256-8WPDBlp6ftBmY/lu0wuuvs3A9KAzEM/A6RqSvYYLm7w=";
  };

  vendorHash = "sha256-jbPFxwrXWwxPamMnbBxFvGBrt38YG7N5fTweAYULEYQ=";

  meta = with lib; {
    description = "Elasticsearch stats exporter for Prometheus";
    mainProgram = "elasticsearch_exporter";
    homepage = "https://github.com/prometheus-community/elasticsearch_exporter";
    license = licenses.asl20;
    maintainers = teams.deshaw.members;
  };
}
