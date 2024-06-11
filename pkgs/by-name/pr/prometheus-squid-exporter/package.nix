{ lib, buildGoModule, fetchFromGitHub, }:

buildGoModule rec {
  pname = "squid-exporter";
  version = "1.11.0";

  src = fetchFromGitHub {
    owner = "boynux";
    repo = "squid-exporter";
    rev = "v${version}";
    sha256 = "sha256-43f6952IqUHoB5CN0p5R5J/sMKbTe2msF9FGqykwMBo=";
  };

  vendorHash = null;

  meta = {
    description = "Squid Prometheus exporter";
    homepage = "https://github.com/boynux/squid-exporter";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ srhb ];
  };
}
