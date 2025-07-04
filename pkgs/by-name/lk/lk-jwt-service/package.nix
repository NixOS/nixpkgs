{
  lib,
  buildGoModule,
  fetchFromGitHub,
  nixosTests,
}:

buildGoModule (finalAttrs: {
  pname = "lk-jwt-service";
  version = "0.2.3";

  src = fetchFromGitHub {
    owner = "element-hq";
    repo = "lk-jwt-service";
    tag = "v${finalAttrs.version}";
    hash = "sha256-DT9W+LFUDrSc/Twjanhrm2zXpQ63zpxLpRY1wf/o0q4=";
  };

  vendorHash = "sha256-47eJO1Ai78RuhlEPn/J1cd+YSqvmfUD8cuPZIqsdxvI=";

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
