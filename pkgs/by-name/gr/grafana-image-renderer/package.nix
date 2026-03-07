{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule (finalAttrs: {
  pname = "grafana-image-renderer";
  version = "5.6.2";

  src = fetchFromGitHub {
    owner = "grafana";
    repo = "grafana-image-renderer";
    tag = "v${finalAttrs.version}";
    hash = "sha256-rbR+TGkTWIpHeGxOQtVQFIeTv1/p8rGfbFp6hSSXQco=";
  };

  vendorHash = "sha256-nRwd1luj8AFjDM67KtinVxRd31lUO+Vv3PDnsv2BMZU=";

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
