{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule (finalAttrs: {
  pname = "ping-exporter";
  version = "1.2.1";

  src = fetchFromGitHub {
    owner = "czerwonk";
    repo = "ping_exporter";
    tag = "v${finalAttrs.version}";
    hash = "sha256-YbdODBKXvBNtIt+Hqu/xA52p5TZGhcVbqZfTcmyyV+Y=";
  };

  vendorHash = "sha256-mZ29jH1572VDLOJb/x3FCI2Q6xVjJ3Ghy/ay343kA3Y=";

  meta = {
    description = "Prometheus exporter for ICMP echo requests";
    mainProgram = "ping_exporter";
    homepage = "https://github.com/czerwonk/ping_exporter";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ nudelsalat ];
  };
})
