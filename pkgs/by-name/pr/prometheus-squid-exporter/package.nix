{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule rec {
  pname = "squid-exporter";
  version = "1.12.0";

  src = fetchFromGitHub {
    owner = "boynux";
    repo = "squid-exporter";
    rev = "v${version}";
    sha256 = "sha256-low1nIL7FbIYfIP7KWPskAQ50Hh+d7JI+ryYoR+mP10=";
  };

  vendorHash = "sha256-0BNhjNveUDd0+X0do4Md58zJjXe3+KN27MPEviNuF3g=";

  meta = {
    description = "Squid Prometheus exporter";
    homepage = "https://github.com/boynux/squid-exporter";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ srhb ];
  };
}
