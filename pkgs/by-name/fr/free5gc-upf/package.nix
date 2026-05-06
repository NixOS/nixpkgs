{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:
buildGoModule (finalAttrs: {
  pname = "free5gc-upf";
  version = "1.0.3";

  src = fetchFromGitHub {
    owner = "free5gc";
    repo = "upf";
    tag = "v${finalAttrs.version}";
    hash = "sha256-BQKM8KtZyQWpNuW8G/nRvFBButAjcwPWDX8CEwd72PY=";
  };

  vendorHash = "sha256-i/UcpdPp6gnS9ituXxtEPscF/I/kDgDiwhTNmS4PHwM=";

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
