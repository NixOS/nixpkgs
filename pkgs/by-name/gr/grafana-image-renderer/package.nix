{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule (finalAttrs: {
  pname = "grafana-image-renderer";
  version = "5.5.1";

  src = fetchFromGitHub {
    owner = "grafana";
    repo = "grafana-image-renderer";
    tag = "v${finalAttrs.version}";
    hash = "sha256-1SntOvAoHf0GwWG3wS2OLY9eiBXhS1mA0OEtKSFOApU=";
  };

  vendorHash = "sha256-kGLvstSkucM0tN5l+Vp78IP9EwDx62kukAiOwYD4Vfs=";

  postPatch = ''
    substituteInPlace go.mod --replace-fail 'go 1.25.6' 'go 1.25.5'
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
