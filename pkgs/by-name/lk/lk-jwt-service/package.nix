{
  lib,
  buildGoModule,
  fetchFromGitHub,
  nixosTests,
}:

buildGoModule (finalAttrs: {
  pname = "lk-jwt-service";
<<<<<<< HEAD
  version = "0.4.0";
=======
  version = "0.3.0";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)

  src = fetchFromGitHub {
    owner = "element-hq";
    repo = "lk-jwt-service";
    tag = "v${finalAttrs.version}";
<<<<<<< HEAD
    hash = "sha256-Qb+6DzaObeNjV+XVXLR6GkgtodIVTqTxC4G4Ef2xFrE=";
  };

  vendorHash = "sha256-GJKSvdv41rRSCGVAgUDxHdXoxRj/h+eDktjRJ3O5QFE=";

  passthru.tests = nixosTests.lk-jwt-service;

  meta = {
    changelog = "https://github.com/element-hq/lk-jwt-service/releases/tag/${finalAttrs.src.tag}";
    description = "Minimal service to issue LiveKit JWTs for MatrixRTC";
    homepage = "https://github.com/element-hq/lk-jwt-service";
    license = lib.licenses.agpl3Plus;
    maintainers = with lib.maintainers; [ kilimnik ];
=======
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
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
    mainProgram = "lk-jwt-service";
  };
})
