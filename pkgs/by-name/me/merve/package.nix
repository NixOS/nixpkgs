{
  lib,
  cmake,
  fetchFromGitHub,
  simdutf,
  gtest,
  nix-update-script,
  stdenv,
  testers,
  validatePkgConfig,
  static ? stdenv.hostPlatform.isStatic,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "merve";
  version = "1.0.1";

  src = fetchFromGitHub {
    owner = "nodejs";
    repo = "merve";
    tag = "v${finalAttrs.version}";
    hash = "sha256-IqUpvnrbnsXlI//xRLbcseMFVLQrwdDCyW1oud3+Ekk=";
  };

  doCheck = true;
  cmakeFlags = [
    (lib.cmakeBool "BUILD_SHARED_LIBS" (!static))
    (lib.cmakeBool "MERVE_TESTING" finalAttrs.finalPackage.doCheck)
    (lib.cmakeBool "MERVE_USE_SIMDUTF" true)
  ];

  nativeBuildInputs = [
    cmake
    validatePkgConfig
  ];
  buildInputs = [
    simdutf
  ];
  checkInputs = [
    gtest
  ];

  passthru = {
    updateScript = nix-update-script { };

    tests.pkg-config = testers.hasPkgConfigModules {
      package = finalAttrs.finalPackage;
      versionCheck = true;
    };
  };

  meta = {
    description = "Lexer to extract named exports via analysis from CommonJS modules";
    homepage = "https://github.com/nodejs/merve";
    changelog = "https://github.com/nodejs/merve/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ aduh95 ];
    platforms = lib.platforms.all;
    pkgConfigModules = [ "merve" ];
  };
})
