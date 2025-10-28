{
  lib,
  fetchFromGitHub,
  buildGoModule,
  nixosTests,
}:

buildGoModule (finalAttrs: {
  pname = "kafka-minion";
  version = "2.2.13";

  src = fetchFromGitHub {
    owner = "redpanda-data";
    repo = "kminion";
    rev = "v${finalAttrs.version}";
    hash = "sha256-s7kHMMU/srqww/N5szTvX6hOFDV9k9hm+0EZUxIj9So=";
  };

  vendorHash = "sha256-vdbSKEWlFH4UkuBxu0LFs8+Rwa4aWTjE8gD4zKuvcs4=";

  doCheck = false;

  ldflags = [
    "-s"
    "-w"
    "-X main.version=${finalAttrs.version}"
    "-X main.builtAt=unknown"
  ];

  passthru = {
    tests = {
      inherit (nixosTests.prometheus-exporters) kafka;
    };
    updateScript = ./update.sh;
  };

  meta = with lib; {
    description = "Feature-rich Prometheus exporter for Apache Kafka written in Go";
    license = licenses.mit;
    maintainers = with maintainers; [ cafkafk ];
    mainProgram = "kminion";
  };
})
