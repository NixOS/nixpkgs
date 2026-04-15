{
  buildGoModule,
  fetchFromGitHub,
  lib,
}:

buildGoModule (finalAttrs: {
  pname = "memcached-exporter";
  version = "0.16.0";

  src = fetchFromGitHub {
    owner = "prometheus";
    repo = "memcached_exporter";
    tag = "v${finalAttrs.version}";
    hash = "sha256-KZWr/BFarH8eamc9MTVDW0vEeQiXAAVyOkCQNheHVdw=";
  };

  vendorHash = "sha256-Um2HUUfaA2tKnX82R0qmW0N+va56GGlED2OoTea3icU=";

  # Tests touch the network
  doCheck = false;

  meta = {
    changelog = "https://github.com/prometheus/memcached_exporter/releases/tag/${finalAttrs.src.tag}";
    description = "Exports metrics from memcached servers for consumption by Prometheus";
    homepage = "https://github.com/prometheus/memcached_exporter";
    license = lib.licenses.asl20;
    mainProgram = "memcached_exporter";
    maintainers = with lib.maintainers; [
      de11n
      despsyched
    ];
  };
})
