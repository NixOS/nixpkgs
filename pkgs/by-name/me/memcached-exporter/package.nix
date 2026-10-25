{
  buildGoModule,
  fetchFromGitHub,
  lib,
}:

buildGoModule (finalAttrs: {
  pname = "memcached-exporter";
  version = "0.18.0";

  src = fetchFromGitHub {
    owner = "prometheus";
    repo = "memcached_exporter";
    tag = "v${finalAttrs.version}";
    hash = "sha256-mOkDi1CWNAvVXZhk/HHeIF4Uq0ieafx5WNp4ZhJ7TUc=";
  };

  vendorHash = "sha256-bQNFKGIodcG/zOLYOB891XNm89Y1mjDjGwab8GYf6Bc=";

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
