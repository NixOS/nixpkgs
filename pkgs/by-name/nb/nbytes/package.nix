{
  lib,
  cmake,
  fetchFromGitHub,
  fetchpatch2,
  gtest,
  nix-update-script,
  stdenv,
  testers,
  validatePkgConfig,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "nbytes";
  version = "0.1.3";

  src = fetchFromGitHub {
    owner = "nodejs";
    repo = "nbytes";
    tag = "v${finalAttrs.version}";
    hash = "sha256-10l/YrvZPwEdEh/Q170WhZUQzdFEpjy7zeKKzYfyoYc=";
  };

  patches = [
    # Use `gtest` from Nixpkgs to allow an offline build
    ./use-nix-googletest.patch
  ];

  outputs = [
    "out"
  ];

  nativeBuildInputs = [
    cmake
    validatePkgConfig
  ];
  buildInputs = [
    gtest
  ];

  cmakeFlags = [
    (lib.cmakeBool "BUILD_SHARED_LIBS" (!stdenv.hostPlatform.isStatic))
  ];

  passthru = {
    updateScript = nix-update-script { };

    tests.pkg-config = testers.hasPkgConfigModules {
      package = finalAttrs.finalPackage;
    };
  };

  meta = {
    description = "Library of byte handling functions extracted from Node.js core";
    homepage = "https://github.com/nodejs/nbytes";
    changelog = "https://github.com/nodejs/nbytes/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ aduh95 ];
    platforms = lib.platforms.all;
    pkgConfigModules = [ "nbytes" ];
  };
})
