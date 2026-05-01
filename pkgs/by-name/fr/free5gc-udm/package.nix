{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:
buildGoModule (finalAttrs: {
  pname = "free5gc-udm";
  version = "1.4.3";

  src = fetchFromGitHub {
    owner = "free5gc";
    repo = "udm";
    tag = "v${finalAttrs.version}";
    hash = "sha256-sxksDLI3xV/vz48F9s3TUga6hORaqRTwIiCzeNS0Ijs=";
  };

  vendorHash = "sha256-dl9rNeh4NurAcTFsca2189ReFdg8e5sMjvVGfe8EMWc=";

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
