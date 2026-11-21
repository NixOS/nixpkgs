{
  lib,
  rustPlatform,
  fetchFromGitHub,
  nixosTests,
  pkg-config,
  aws-lc,
  cacert,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "lk-jwt-service";
  version = "0.10.0";

  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "element-hq";
    repo = "lk-jwt-service";
    tag = "v${finalAttrs.version}";
    hash = "sha256-wZCIWkq1dwoj0Se86jHw0EIGAFUkiOZ+Dc94oTr+6a0=";
  };

  cargoHash = "sha256-lUsjLpTYZvPJc3UIxKwiMOiJZb2+w8Ju00gn7wxcVGY=";

  buildInputs = [
    aws-lc
  ];

  nativeBuildInputs = [
    pkg-config
  ];

  # Tests spawn a local webserver
  __darwinAllowLocalNetworking = true;

  checkInputs = [
    cacert
  ];

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
