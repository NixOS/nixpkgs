{
  buildGoModule,
  lib,
  fetchFromGitHub,
}:

buildGoModule (finalAttrs: {
  __structuredAttrs = true;
  pname = "prometheus-xray-exporter";
  version = "0.2.0";

  src = fetchFromGitHub {
    owner = "compassvpn";
    repo = "xray-exporter";
    tag = "v${finalAttrs.version}";
    hash = "sha256-GP0CFphMgSS8ezSuRoHQJMuehCND4glrXE9fye0PhTE=";
  };

  vendorHash = "sha256-yRxy44SnEFa7yOJyiOgFTk+Z4s5HOJ4cMjcf8VTTfQk=";

  meta = {
    description = "Prometheus exporter for Xray-core metrics";
    mainProgram = "xray-exporter";
    homepage = "https://github.com/compassvpn/xray-exporter";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ podocarp ];
  };
})
