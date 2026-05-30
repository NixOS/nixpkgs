{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  libiconv,
  nix-update-script,
  testers,
  validatePkgConfig,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "simdutf";
  version = "9.0.0";

  src = fetchFromGitHub {
    owner = "simdutf";
    repo = "simdutf";
    rev = "v${finalAttrs.version}";
    hash = "sha256-psMMF26+nTwdbtPfFFE3fXkatrh9Bp9qMsrdI/FmrDg=";
  };

  cmakeFlags = [
    (lib.cmakeBool "BUILD_SHARED_LIBS" (!stdenv.hostPlatform.isStatic))
  ];

  nativeBuildInputs = [
    cmake
    validatePkgConfig
  ];

  buildInputs = [
    libiconv
  ];

  passthru = {
    updateScript = nix-update-script { };

    tests.pkg-config = testers.hasPkgConfigModules {
      package = finalAttrs.finalPackage;
    };
  };

  meta = {
    description = "Unicode routines validation and transcoding at billions of characters per second";
    homepage = "https://github.com/simdutf/simdutf";
    license = with lib.licenses; [
      asl20
      mit
    ];
    maintainers = with lib.maintainers; [ wineee ];
    pkgConfigModules = [ "simdutf" ];
    platforms = lib.platforms.all;
  };
})
