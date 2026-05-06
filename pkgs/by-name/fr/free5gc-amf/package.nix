{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:
buildGoModule (finalAttrs: {
  pname = "free5gc-amf";
  version = "1.4.3";

  src = fetchFromGitHub {
    owner = "free5gc";
    repo = "amf";
    tag = "v${finalAttrs.version}";
    hash = "sha256-oH01ySslrVhreFIYcEGs3jBZy37wylwhtz8f4VjSlgk=";
  };

  vendorHash = "sha256-plUoCtHK8/cuYmPosV7ISIlqZGJZUJ4L0Fd0cWV+3zo=";

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
