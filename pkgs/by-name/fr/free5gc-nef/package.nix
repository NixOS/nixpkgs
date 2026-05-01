{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:
buildGoModule (finalAttrs: {
  pname = "free5gc-nef";
  version = "1.2.3";

  src = fetchFromGitHub {
    owner = "free5gc";
    repo = "nef";
    tag = "v${finalAttrs.version}";
    hash = "sha256-FaLL+RMAub8weCzE68UL6ZpjMf2GRfoekt1X2QjtVEw=";
  };

  vendorHash = "sha256-GS86eLcF0hlnnMPFsKGfhsUDcnjMQVq30oe0KxEbAzQ=";

  ldflags = [
    "-X github.com/free5gc/util/version.VERSION=v${finalAttrs.version}"
  ];

  __structuredAttrs = true;

  meta = {
    description = "Open source 5G core network based on 3GPP R15";
    homepage = "https://free5gc.org/";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ felbinger ];
    platforms = lib.platforms.linux;
  };
})
