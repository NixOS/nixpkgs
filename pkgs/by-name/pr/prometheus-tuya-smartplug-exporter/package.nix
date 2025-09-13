{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

let
  version = "1.0.4";
  src = fetchFromGitHub {
    owner = "rkosegi";
    repo = "tuya-smartplug-exporter";
    rev = "v${version}";
    hash = "sha256-6n14NLVV8jhg6a/WAR149px/nM0eKwgOIe5qBG8jbKA=";
  };
in
buildGoModule {
  pname = "prometheus-tuya-smartplug-exporter";
  vendorHash = "sha256-ABIId1VSt3AgO4gHJakkmJrXClk0Q3dpY+DPLfmG3kw=";
  inherit src version;

  ldflags = [
    "-X github.com/prometheus/common/version.Version=${version}"
    "-X github.com/prometheus/common/version.Revision=${src.rev}"
    "-X github.com/prometheus/common/version.Branch=unknown"
  ];

  meta = {
    description = "Prometheus exporter for Tuya-based smartplug devices";
    homepage = "https://github.com/rkosegi/tuya-smartplug-exporter";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ onny ];
    mainProgram = "tuya-smartplug-exporter";
  };
}
