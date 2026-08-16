{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule (finalAttrs: {
  pname = "prometheus-storagebox-exporter";
  version = "1.1.0";

  src = fetchFromGitHub {
    owner = "fleaz";
    repo = "prometheus-storagebox-exporter";
    hash = "sha256-eHS0/nrfl6pnB4GjbHAaQKUOHJYGy+a56N+/WNDht6Q=";
    tag = "v${finalAttrs.version}";
  };

  vendorHash = "sha256-NlTAmurQz7c+Gor0ExQoXUxAzcuCnk0ra3J4bojoFeU=";

  meta = {
    description = "Prometheus exporter for Hetzner storage boxes";
    homepage = "https://github.com/fleaz/prometheus-storagebox-exporter";
    license = lib.licenses.mit;
    mainProgram = "prometheus-storagebox-exporter";
    maintainers = with lib.maintainers; [
      erethon
      fleaz
    ];
  };
})
