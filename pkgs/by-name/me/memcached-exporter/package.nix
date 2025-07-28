{
  buildGoModule,
  fetchFromGitHub,
  lib,
}:

buildGoModule (finalAttrs: {
  pname = "memcached-exporter";
  version = "0.15.3";

  src = fetchFromGitHub {
    owner = "prometheus";
    repo = "memcached_exporter";
    tag = "v${finalAttrs.version}";
    hash = "sha256-Y2y8XMR+YHbxFQFYqwtQ4aRi71jD6l3witEwjxAjuOc=";
  };

  vendorHash = "sha256-Q2b8/QA12HI6ynLU5aNmwOal+snHd1Be6p3UWk4DJhw=";

  # Tests touch the network
  doCheck = false;

  meta = {
    changelog = "https://github.com/prometheus/memcached_exporter/releases/tag/${finalAttrs.src.tag}";
    description = "Exports metrics from memcached servers for consumption by Prometheus";
    homepage = "https://github.com/prometheus/memcached_exporter";
    license = lib.licenses.asl20;
    mainProgram = "memcached_exporter";
    teams = with lib.teams; [ deshaw ];
  };
})
