{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "prometheus-dnssec-exporter";
  version = "0-unstable-2023-03-05";

  src = fetchFromGitHub {
    owner = "chrj";
    repo = "prometheus-dnssec-exporter";
    rev = version;
    hash = "sha256-SGoQKSgTRfSyA65xEZ9P7Z956sLMhB88h3HaXmFywiQ=";
  };

  vendorHash = "sha256-u7X8v7h1aL8B1el4jFzGRKHvnaK+Rz0OCitaC6xgyjw=";

  doCheck = false;

  meta = with lib; {
    inherit (src.meta) homepage;
    description = "DNSSEC Exporter for Prometheus";
    license = licenses.mit;
    maintainers = with maintainers; [ swendel ];
  };
}
