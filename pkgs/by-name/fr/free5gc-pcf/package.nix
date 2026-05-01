{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:
buildGoModule (finalAttrs: {
  pname = "free5gc-pcf";
  version = "1.4.3";

  src = fetchFromGitHub {
    owner = "free5gc";
    repo = "pcf";
    tag = "v${finalAttrs.version}";
    hash = "sha256-nxs29ikm/NQTnVc2ANzZxMqC9Usui4E+0GrL5taO9aM=";
  };

  vendorHash = "sha256-m1IqVKnsT7vWJMWHGrA4QB3aXIkGsIJQQ7NAGT/Th38=";

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
