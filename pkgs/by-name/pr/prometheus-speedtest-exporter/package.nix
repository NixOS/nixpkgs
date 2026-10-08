{
  buildGoModule,
  lib,
  fetchFromGitHub,
}:

buildGoModule (finalAttrs: {
  __structuredAttrs = true;
  pname = "prometheus-speedtest-exporter";
  version = "1.2.0";

  src = fetchFromGitHub {
    owner = "podocarp";
    repo = "speedtest_exporter";
    tag = "v${finalAttrs.version}";
    hash = "sha256-ZYdQWEEn+zYp0kA6h34fdy1KxQ1PxqWpt0RpXBrd7pE=";
  };

  vendorHash = "sha256-42xxNgYeRXGCyRpz6D4E68l2mm+gE2RSyOeLHOIQrjI=";

  meta = {
    description = "Speedtest.net Exporter for the Prometheus monitoring system";
    mainProgram = "speedtest_exporter";
    homepage = "https://github.com/podocarp/speedtest_exporter";
    license = lib.licenses.gpl3Only;
    maintainers = with lib.maintainers; [ podocarp ];
  };
})
