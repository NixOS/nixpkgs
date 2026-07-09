{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule (finalAttrs: {
  pname = "grafana-image-renderer";
  version = "5.9.0";

  src = fetchFromGitHub {
    owner = "grafana";
    repo = "grafana-image-renderer";
    tag = "v${finalAttrs.version}";
    hash = "sha256-nTYdSMNiNg97UEWQgVxi5umFU7XsKXp4QHjeVoo8L9M=";
  };

  vendorHash = "sha256-QiseTdsFOBg3aDYpdmLHfXL9eFll6iJo4wSKwXvdGnM=";

  postPatch = ''
    substituteInPlace go.mod --replace-fail 'go 1.26.4' 'go 1.26.3'
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
