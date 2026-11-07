{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule rec {
  pname = "nut-exporter";
  version = "3.3.0";

  src = fetchFromGitHub {
    owner = "DRuggeri";
    repo = "nut_exporter";
    rev = "v${version}";
    sha256 = "sha256-ZbX5gHQhIVFzxMlx4xZYaEHLuiMNvTmJ5puAjC2rgfw=";
  };

  vendorHash = "sha256-tqlsqAgZzFOhyQkikHAWr/NyOGFDW6yh2iiK0zuyUbU=";

  meta = {
    description = "Prometheus exporter for Network UPS Tools";
    mainProgram = "nut_exporter";
    homepage = "https://github.com/DRuggeri/nut_exporter";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ jhh ];
  };
}
