{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:
buildGoModule rec {
  pname = "elasticsearch_exporter";
  version = "1.10.0";

  src = fetchFromGitHub {
    owner = "prometheus-community";
    repo = "elasticsearch_exporter";
    rev = "v${version}";
    hash = "sha256-xVDqyYYwzxfFxZ3K2SMFfPoJw47SXS6czsWLC++LOOk=";
  };

  vendorHash = "sha256-8y0M1b34eJpuHOuXPemhB5kKwBSgU7cMFxOaIZFS/bo=";

  meta = {
    description = "Elasticsearch stats exporter for Prometheus";
    mainProgram = "elasticsearch_exporter";
    homepage = "https://github.com/prometheus-community/elasticsearch_exporter";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [
      de11n
      despsyched
    ];
  };
}
