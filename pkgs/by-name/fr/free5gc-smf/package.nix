{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:
buildGoModule (finalAttrs: {
  pname = "free5gc-smf";
  version = "1.4.3";

  src = fetchFromGitHub {
    owner = "free5gc";
    repo = "smf";
    tag = "v${finalAttrs.version}";
    hash = "sha256-V5Z0AZMloCRgsCI0j8j9dnb2a+gKhu3M29Po3wY0RMk=";
  };

  vendorHash = "sha256-8sVuhlLN00TxTaQFtETvsuAIoW3yjy/CBGF4PQp2XQ4=";

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
