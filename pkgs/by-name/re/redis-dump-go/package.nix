{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule rec {
  pname = "redis-dump-go";
  version = "0.8.2";

  vendorHash = null;

  src = fetchFromGitHub {
    owner = "yannh";
    repo = "redis-dump-go";
    tag = "v${version}";
    hash = "sha256-+5iYigtMQvd6D90mpKyMa7ZKm2UDtCG91uFZ7dURBT4=";
  };

  meta = {
    homepage = "https://github.com/yannh/redis-dump-go";
    description = "Dump Redis keys to a file in RESP format using multiple connections";
    license = lib.licenses.mit;
    maintainers = [ lib.maintainers.richiejp ];
  };
}
