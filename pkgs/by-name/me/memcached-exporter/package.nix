{
  buildGoModule,
  fetchFromGitHub,
  lib,
}:

buildGoModule (finalAttrs: {
  pname = "memcached-exporter";
  version = "0.15.4";

  src = fetchFromGitHub {
    owner = "prometheus";
    repo = "memcached_exporter";
    tag = "v${finalAttrs.version}";
    hash = "sha256-3xqMq9bxxz7/GChHlCBIHb8HZ5TT5MsfBVE8ap533nc=";
  };

  vendorHash = "sha256-Fcz02viZxXhzTW23GchU4lKi+WriMdpSZKoqXCCn9MA=";

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
