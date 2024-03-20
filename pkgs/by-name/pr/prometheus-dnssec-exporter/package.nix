{ lib, buildGoModule, fetchFromGitHub, nixosTests }:

buildGoModule rec {
  pname = "prometheus-dnssec-exporter";
  version = "b638685ed8d5919a88b45e85b3aec702f0fcc393";

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
    maintainers = with maintainers; [ SebastianWendel ];
  };
}
