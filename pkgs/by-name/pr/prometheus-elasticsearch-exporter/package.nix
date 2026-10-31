{
  lib,
  buildGoModule,
  fetchFromGitHub,
  nixosTests,
}:
buildGoModule (finalAttrs: {
  pname = "elasticsearch_exporter";
  version = "1.11.0";

  src = fetchFromGitHub {
    owner = "prometheus-community";
    repo = "elasticsearch_exporter";
    rev = "v${finalAttrs.version}";
    hash = "sha256-RZ/GyBVZjP7Co6/QORhhllC62x1V7Cfujg821g7Kyf0=";
  };

  vendorHash = "sha256-+Xmj+oNv9ODlKOpnwpGyjz0cZT4F4txJr0KcCMtUwQc=";

  passthru.tests = { inherit (nixosTests.prometheus-exporters) elasticsearch; };

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
})
