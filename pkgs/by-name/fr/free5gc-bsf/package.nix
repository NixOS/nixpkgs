{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:
buildGoModule (finalAttrs: {
  pname = "free5gc-bsf";
  version = "1.0.2";

  src = fetchFromGitHub {
    owner = "free5gc";
    repo = "bsf";
    tag = "v${finalAttrs.version}";
    hash = "sha256-LIsLaAt3EZMUJBIVErFUP/DLrJnFhu+8WJMiKAgxUYE=";
  };

  vendorHash = "sha256-2T6Al3/Z7TCRIAk96ygT9LOe2hmqsyPfKuXqjW8LGig=";

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
