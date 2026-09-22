{
  buildGoModule,
  fetchFromGitHub,
  lib,
}:

buildGoModule (finalAttrs: {
  pname = "memcached-exporter";
  version = "0.17.0";

  src = fetchFromGitHub {
    owner = "prometheus";
    repo = "memcached_exporter";
    tag = "v${finalAttrs.version}";
    hash = "sha256-VTEkRibS6jtLqHhUDZFDeaPf438fuemfBMzOj3iRBWw=";
  };

  vendorHash = "sha256-LdkE6seovYH1Srkn2mCR3VJugoCHz3fZJJuhKKdtGVo=";

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
