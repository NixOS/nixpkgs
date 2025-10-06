{
  lib,
  buildGoModule,
  fetchFromGitHub,
  nixosTests,
}:

buildGoModule (finalAttrs: {
  pname = "lk-jwt-service";
  version = "0.3.0";

  src = fetchFromGitHub {
    owner = "element-hq";
    repo = "lk-jwt-service";
    tag = "v${finalAttrs.version}";
    hash = "sha256-fA33LZkozPTng47kunXWkfUExVbMZsiL8Dtkm1hLV6U=";
  };

  vendorHash = "sha256-0A9pd+PAsGs4KS2BnCxc7PAaUAV3Z+XKNqSrmYvxNeM=";

  passthru.tests = nixosTests.lk-jwt-service;

  meta = with lib; {
    changelog = "https://github.com/element-hq/lk-jwt-service/releases/tag/${finalAttrs.src.tag}";
    description = "Minimal service to issue LiveKit JWTs for MatrixRTC";
    homepage = "https://github.com/element-hq/lk-jwt-service";
    license = licenses.agpl3Plus;
    maintainers = with maintainers; [ kilimnik ];
    mainProgram = "lk-jwt-service";
  };
})
