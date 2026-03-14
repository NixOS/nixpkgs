{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule (finalAttrs: {
  pname = "grafana-image-renderer";
  version = "5.7.1";

  src = fetchFromGitHub {
    owner = "grafana";
    repo = "grafana-image-renderer";
    tag = "v${finalAttrs.version}";
    hash = "sha256-0n9esm8j3zRMUzFPrXrcllEen+F6XpL3yPY5KBY8H9g=";
  };

  vendorHash = "sha256-nRwd1luj8AFjDM67KtinVxRd31lUO+Vv3PDnsv2BMZU=";

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
