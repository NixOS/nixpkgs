{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule (finalAttrs: {
  pname = "ping-exporter";
  version = "1.2.3";

  src = fetchFromGitHub {
    owner = "czerwonk";
    repo = "ping_exporter";
    tag = "v${finalAttrs.version}";
    hash = "sha256-r9+cx5mU3aW9Yf7LoRm1G8izFt3D4gMOlLGuNo4L5z0=";
  };

  vendorHash = "sha256-JKkvg09rtnc4CCUoZ5+NZEVcHh5nLFvkhaBQS4IksF4=";

  meta = {
    description = "Prometheus exporter for ICMP echo requests";
    mainProgram = "ping_exporter";
    homepage = "https://github.com/czerwonk/ping_exporter";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ nudelsalat ];
  };
})
