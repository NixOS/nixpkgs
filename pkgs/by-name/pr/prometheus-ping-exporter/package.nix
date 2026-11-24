{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule (finalAttrs: {
  pname = "ping-exporter";
  version = "1.3.2";

  src = fetchFromGitHub {
    owner = "czerwonk";
    repo = "ping_exporter";
    tag = "v${finalAttrs.version}";
    hash = "sha256-fBUF8QLg792H4PUXDTUAYjSQiXq/tdq/CDcDbi9Pd7A=";
  };

  vendorHash = "sha256-UV0X73UhLFST7/q+qm7p5Iv1gsGi401GfwBKDfDQR1c=";

  meta = {
    description = "Prometheus exporter for ICMP echo requests";
    mainProgram = "ping_exporter";
    homepage = "https://github.com/czerwonk/ping_exporter";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ nudelsalat ];
  };
})
