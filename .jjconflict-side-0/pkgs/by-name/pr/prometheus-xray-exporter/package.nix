{
  buildGoModule,
  lib,
  fetchFromGitHub,
}:

buildGoModule (finalAttrs: {
  __structuredAttrs = true;
  pname = "prometheus-xray-exporter";
  version = "1.0.0";

  src = fetchFromGitHub {
    owner = "podocarp";
    repo = "xray-exporter";
    tag = "v${finalAttrs.version}";
    hash = "sha256-Ocex/D1OYOlQ2BZ835qrlXaEuMdXaglIPpVzfo0OZ5g=";
  };

  vendorHash = "sha256-yRxy44SnEFa7yOJyiOgFTk+Z4s5HOJ4cMjcf8VTTfQk=";

  meta = {
    description = "Prometheus exporter for Xray-core metrics";
    mainProgram = "xray-exporter";
    homepage = "https://github.com/podocarp/xray-exporter";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ podocarp ];
  };
})
