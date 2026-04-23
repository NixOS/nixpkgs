{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule (finalAttrs: {
  pname = "grafana-image-renderer";
  version = "5.7.2";

  src = fetchFromGitHub {
    owner = "grafana";
    repo = "grafana-image-renderer";
    tag = "v${finalAttrs.version}";
    hash = "sha256-b3+mh6RyXeHwFJQV9O0x/L0AMwF4P+dtS0s+L20PqJI=";
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
