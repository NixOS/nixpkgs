{
  stdenv,
  lib,
  fetchFromGitHub,
  cmake,
  ninja,
  ctestCheckHook,
  testers,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "double-conversion";
  version = "3.4.0";

  src = fetchFromGitHub {
    owner = "google";
    repo = "double-conversion";
    tag = "v${finalAttrs.version}";
    hash = "sha256-gxaPqQ51RyXZaTHkvh4RBpedPopcRiuWDoT+PPbI1uw=";
  };

  outputs = [
    "out"
    "dev"
  ];

  nativeBuildInputs = [
    cmake
    ninja
    ctestCheckHook
  ];

  doCheck = true;

  cmakeFlags = [
    (lib.cmakeBool "BUILD_TESTING" true)
    (lib.cmakeBool "BUILD_SHARED_LIBS" stdenv.hostPlatform.hasSharedLibraries)
  ];

  # Case sensitivity issue
  preConfigure = lib.optionalString stdenv.hostPlatform.isDarwin ''
    rm BUILD
  '';

  passthru = {
    tests.pkg-config = testers.testMetaPkgConfig finalAttrs.finalPackage;
  };

  meta = {
    pkgConfigModules = [ "double-conversion" ];
    changelog = "https://github.com/google/double-conversion/blob/${finalAttrs.src.tag}/Changelog";
    description = "Binary-decimal and decimal-binary routines for IEEE doubles";
    homepage = "https://github.com/google/double-conversion";
    license = lib.licenses.bsd3;
    platforms = lib.platforms.unix ++ lib.platforms.windows;
    maintainers = with lib.maintainers; [ fzakaria ];
  };
})
