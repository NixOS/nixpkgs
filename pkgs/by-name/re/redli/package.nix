{
  lib,
  fetchFromGitHub,
  buildGoModule,
}:

buildGoModule (finalAttrs: {
  pname = "redli";
  version = "0.17.0";

  src = fetchFromGitHub {
    owner = "IBM-Cloud";
    repo = "redli";
    tag = "v${finalAttrs.version}";
    hash = "sha256-RSiXJwsQ1hj9+hIA4Q/xadNsS3skJhdGyJBV2LUX3n4=";
  };

  vendorHash = "sha256-WMDQG69VWQyhDyEBzHaUIPXJChfdl/jO/POqtPxIDGU=";

  meta = {
    description = "Humane alternative to the Redis-cli and TLS";
    homepage = "https://github.com/IBM-Cloud/redli";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ tchekda ];
    mainProgram = "redli";
  };
})
