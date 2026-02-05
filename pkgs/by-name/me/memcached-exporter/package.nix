{
  buildGoModule,
  fetchFromGitHub,
  lib,
}:

buildGoModule (finalAttrs: {
  pname = "memcached-exporter";
  version = "0.15.5";

  src = fetchFromGitHub {
    owner = "prometheus";
    repo = "memcached_exporter";
    tag = "v${finalAttrs.version}";
    hash = "sha256-f9ME3JOeQDcqXrgbX9MiRGvJJz2i3vYBwnjZAYChnlY=";
  };

  vendorHash = "sha256-8+9qze2peeXIYa9Mm+sS5/2TQMpJGAHo687LJEZS7So=";

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
