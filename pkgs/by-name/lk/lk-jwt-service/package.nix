{
  lib,
  buildGoModule,
  fetchFromGitHub,
  nixosTests,
}:

buildGoModule (finalAttrs: {
  pname = "lk-jwt-service";
  version = "0.4.1";

  src = fetchFromGitHub {
    owner = "element-hq";
    repo = "lk-jwt-service";
    tag = "v${finalAttrs.version}";
    hash = "sha256-x3QYq+PT0MFcRR50CG4NpCxv5KkoCLWzUEkPSdQnZX0=";
  };

  vendorHash = "sha256-GJKSvdv41rRSCGVAgUDxHdXoxRj/h+eDktjRJ3O5QFE=";

  passthru.tests = nixosTests.lk-jwt-service;

  meta = {
    changelog = "https://github.com/element-hq/lk-jwt-service/releases/tag/${finalAttrs.src.tag}";
    description = "Minimal service to issue LiveKit JWTs for MatrixRTC";
    homepage = "https://github.com/element-hq/lk-jwt-service";
    license = lib.licenses.agpl3Plus;
    maintainers = with lib.maintainers; [ kilimnik ];
    mainProgram = "lk-jwt-service";
  };
})
