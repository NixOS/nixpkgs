{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule (finalAttrs: {
  pname = "ping-exporter";
  version = "1.3.1";

  src = fetchFromGitHub {
    owner = "czerwonk";
    repo = "ping_exporter";
    tag = "v${finalAttrs.version}";
    hash = "sha256-/fjegXtPh1PuQZtCItYXY2/yUxSWfmfFZyO/pL5GxjU=";
  };

  vendorHash = "sha256-i6iYQ0X35y5eIunVJChP55U3V21b8f5atqRB/8HTXC0=";

  meta = {
    description = "Prometheus exporter for ICMP echo requests";
    mainProgram = "ping_exporter";
    homepage = "https://github.com/czerwonk/ping_exporter";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ nudelsalat ];
  };
})
