{
  lib,
  cmake,
  fetchFromGitHub,
  gtest,
  openssl,
  nix-update-script,
  stdenv,
  testers,
  validatePkgConfig,
  static ? stdenv.hostPlatform.isStatic,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "ncrypto";
  version = "1.1.0";

  src = fetchFromGitHub {
    owner = "nodejs";
    repo = "ncrypto";
    tag = "v${finalAttrs.version}";
    hash = "sha256-9lAlIdY1gmzGR6+FldQQjj09e41mvl2V0Lf/iFmeQhU=";
  };

  nativeBuildInputs = [
    cmake
    validatePkgConfig
  ];
  buildInputs = [ openssl ];

  doCheck = true;
  checkInputs = [ gtest ];
  cmakeFlags = [
    (lib.cmakeBool "BUILD_SHARED_LIBS" (!static))
    (lib.cmakeBool "NCRYPTO_SHARED_LIBS" true)
    (lib.cmakeBool "NCRYPTO_TESTING" finalAttrs.finalPackage.doCheck)
  ];

  passthru = {
    updateScript = nix-update-script { };

    tests.pkg-config = testers.hasPkgConfigModules {
      package = finalAttrs.finalPackage;
      versionCheck = true;
    };
  };

  meta = {
    description = "Library of byte handling functions extracted from Node.js core";
    homepage = "https://github.com/nodejs/ncrypto";
    changelog = "https://github.com/nodejs/ncrypto/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ aduh95 ];
    platforms = lib.platforms.all;
    pkgConfigModules = [ "ncrypto" ];
  };
})
