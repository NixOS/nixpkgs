{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule (finalAttrs: {
  pname = "grafana-image-renderer";
  version = "5.0.11";

  src = fetchFromGitHub {
    owner = "grafana";
    repo = "grafana-image-renderer";
    tag = "v${finalAttrs.version}";
    hash = "sha256-fHIxtIRCxxJVHUA3r1ddCpOAsJ8QCJoCbUWagFcj4+I=";
  };

  vendorHash = "sha256-wA1XeLO2bYwq7HZOQ5UNcdqqJdEWRUxFoAQucXAj48k=";

  subPackages = [ "." ];

  meta = with lib; {
    homepage = "https://github.com/grafana/grafana-image-renderer";
    description = "Grafana backend plugin that handles rendering of panels & dashboards to PNGs using headless browser (Chromium/Chrome)";
    mainProgram = "grafana-image-renderer";
    license = licenses.asl20;
    maintainers = with maintainers; [ ma27 ];
  };
})
