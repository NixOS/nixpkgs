{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule (finalAttrs: {
  pname = "lk-jwt-service";
  version = "0.2.2";

  src = fetchFromGitHub {
    owner = "element-hq";
    repo = "lk-jwt-service";
    tag = "v${finalAttrs.version}";
    hash = "sha256-ONL2qKBXL2FtTv5Eao61qPKWP2h9t3KyoHlS5nAHMGA=";
  };

  vendorHash = "sha256-47eJO1Ai78RuhlEPn/J1cd+YSqvmfUD8cuPZIqsdxvI=";

  meta = with lib; {
    changelog = "https://github.com/element-hq/lk-jwt-service/releases/tag/${finalAttrs.src.tag}";
    description = "Minimal service to issue LiveKit JWTs for MatrixRTC";
    homepage = "https://github.com/element-hq/lk-jwt-service";
    license = licenses.agpl3Plus;
    maintainers = with maintainers; [ kilimnik ];
    mainProgram = "lk-jwt-service";
  };
})
