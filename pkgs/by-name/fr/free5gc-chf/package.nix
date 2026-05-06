{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:
buildGoModule (finalAttrs: {
  pname = "free5gc-chf";
  version = "1.2.3";

  src = fetchFromGitHub {
    owner = "free5gc";
    repo = "chf";
    tag = "v${finalAttrs.version}";
    hash = "sha256-rKAig3y7rGDoUpMoB5k58eIf+w7S3PhTsxObzLmUrmM=";
  };

  vendorHash = "sha256-/7GH6f4+Ao183AWxJIv6cndhoVE6Dnishgl8ER0knsQ=";

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
