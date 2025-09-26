{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule {
  pname = "prometheus-storagebox-exporter";
  version = "0-unstable-2025-07-28";

  src = fetchFromGitHub {
    owner = "fleaz";
    repo = "prometheus-storagebox-exporter";
    hash = "sha256-HGUAvoLIVXwZT/CJ1yj9H6ClNRwiJ8rjjluAQ6GdBME=";
    rev = "e03cfd5f60f7847b74de2f6f47690bc03b7c157a";
  };

  vendorHash = "sha256-w2S8LWQyDLnUba7+YnTk7GhRXR/agbF5GFIeOPk8w64=";

  meta = {
    description = "Prometheus exporter for Hetzner storage boxes";
    homepage = "https://github.com/fleaz/prometheus-storage-exporter";
    license = lib.licenses.mit;
    mainProgram = "prometheus-storagebox-exporter";
    maintainers = with lib.maintainers; [
      erethon
    ];
  };
}
