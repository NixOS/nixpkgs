{
  lib,
  stdenv,
  fetchFromGitHub,
  buildGoModule,
  nixosTests,
}:

buildGoModule {
  pname = "kafka-minion";
  version = "2.2.8";

  src = fetchFromGitHub {
    owner = "redpanda-data";
    repo = "kminion";
    rev = "v${version}";
    hash = "sha256-y9FcvWJ9izS5vkgDsiHa8TKdS4jOYLMOHJUyCPsmTZ4=";
  };

  vendorHash = "sha256-ekOS16B2AIB4LQXOLbiaOMUvtqy8f51UJfu0uhn4gzg=";

  doCheck = false;

  ldflags = [
    "-s"
    "-w"
    "-X main.version=${version}"
    "-X main.builtAt=unknown"
  ];

  passthru = {
    tests = {
      inherit (nixosTests.prometheus-exporters) kafka;
    };
    updateScript = ./update.sh;
  };

  meta = with lib; {
    description = "KMinion is a feature-rich Prometheus exporter for Apache Kafka written in Go";
    license = licenses.mit;
    maintainers = with maintainers; [ cafkafk ];
    mainProgram = "kminion";
  };
}
