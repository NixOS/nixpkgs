{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:
buildGoModule {
  pname = "prometheus-dnssec-exporter";
  version = "0-unstable-2023-03-05";

  src = fetchFromGitHub {
    owner = "chrj";
    repo = "prometheus-dnssec-exporter";
    rev = "b638685ed8d5919a88b45e85b3aec702f0fcc393";
    hash = "sha256-SGoQKSgTRfSyA65xEZ9P7Z956sLMhB88h3HaXmFywiQ=";
  };

  vendorHash = "sha256-u7X8v7h1aL8B1el4jFzGRKHvnaK+Rz0OCitaC6xgyjw=";

  meta = {
    homepage = "https://github.com/chrj/prometheus-dnssec-exporter";
    description = "DNSSEC Exporter for Prometheus";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ swendel ];
  };
}
