{
  lib,
  rustPlatform,
  fetchFromGitHub,
  nixosTests,
  cacert,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "lk-jwt-service";
  version = "0.7.0";

  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "element-hq";
    repo = "lk-jwt-service";
    tag = "v${finalAttrs.version}";
    hash = "sha256-uygFVEr0abUux04ShDitYpQJIy4vm0ysDvDtKQiMG1E=";
  };

  cargoHash = "sha256-fWaeKuE9nr+yKT8ZInR79LDwwg1VsA2jdN/wdhtgln8=";

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
