{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule (finalAttrs: {
  pname = "grafana-image-renderer";
  version = "5.7.3";

  src = fetchFromGitHub {
    owner = "grafana";
    repo = "grafana-image-renderer";
    tag = "v${finalAttrs.version}";
    hash = "sha256-CrJkBx2BMGlFtqXR174A5CVTH2GIZHTVxxwJjCi68pg=";
  };

  vendorHash = "sha256-3nd0m0PltTiJX5e1tbQ7LSgUmDRXC8nRktOVAIgHOCU=";

  postPatch = ''
    substituteInPlace go.mod --replace-fail 'go 1.26.1' 'go 1.25.7'
  '';

  subPackages = [ "." ];

  meta = {
    homepage = "https://github.com/grafana/grafana-image-renderer";
    description = "Grafana backend plugin that handles rendering of panels & dashboards to PNGs using headless browser (Chromium/Chrome)";
    mainProgram = "grafana-image-renderer";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ ma27 ];
  };
})
