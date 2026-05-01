{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:
buildGoModule (finalAttrs: {
  pname = "free5gc-ausf";
  version = "1.4.3";

  src = fetchFromGitHub {
    owner = "free5gc";
    repo = "ausf";
    tag = "v${finalAttrs.version}";
    hash = "sha256-S96QhcerwA2c/fW7J0C4HlcQVeSHrob4VCKOSd4iUpo=";
  };

  vendorHash = "sha256-8oATdtM8pA8KKgPHFCqsEM0Lo93ZBkoTqLRPfHywCOY=";

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
