{
  lib,
  rustPlatform,
  fetchFromGitHub,
  nixosTests,
  cacert,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "lk-jwt-service";
  version = "0.8.0";

  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "element-hq";
    repo = "lk-jwt-service";
    tag = "v${finalAttrs.version}";
    hash = "sha256-xq73bH73wVtePtXdahyF5o7Fii1oUwPkjgrRYb0T62k=";
  };

  cargoHash = "sha256-fWaeKuE9nr+yKT8ZInR79LDwwg1VsA2jdN/wdhtgln8=";

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
