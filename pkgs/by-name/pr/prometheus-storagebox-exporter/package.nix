{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule rec {
  pname = "prometheus-storagebox-exporter";
  version = "1.0.0";

  src = fetchFromGitHub {
    owner = "fleaz";
    repo = "prometheus-storagebox-exporter";
    hash = "sha256-sufxNnHAdOaYEzKj9vriDrJF6Tq4Eim3Z45FEuuG97Q=";
    tag = "v${version}";
  };

  vendorHash = "sha256-hWM7JnL0x+vsUrQsJZGM3z2jB3F1wtjKWmX8j+WnjKY=";

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
}
