{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule rec {
  pname = "squid-exporter";
  version = "1.13.0";

  src = fetchFromGitHub {
    owner = "boynux";
    repo = "squid-exporter";
    rev = "v${version}";
    hash = "sha256-UH/+YbUiAqgAJ8Xm/6cZg5imFSgA6LHU6+SHseq5IPw=";
  };

  vendorHash = "sha256-aY0tW4OH8OHEMF3cLYTAeOd0VItSP0cTCwF4s7wdqTk=";

  meta = {
    description = "Squid Prometheus exporter";
    homepage = "https://github.com/boynux/squid-exporter";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ srhb ];
  };
}
