{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:
buildGoModule (finalAttrs: {
  pname = "free5gc-nrf";
  version = "1.4.3";

  src = fetchFromGitHub {
    owner = "free5gc";
    repo = "nrf";
    tag = "v${finalAttrs.version}";
    hash = "sha256-NACwoa5ulIkEPtbHO5sFIyTPu5CDlj+AOCedMgNx3z4=";
  };

  vendorHash = "sha256-xfrDXKcAJvYYjplBTXS7SezQX9rLhRomNXilFYVUyLM=";

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
