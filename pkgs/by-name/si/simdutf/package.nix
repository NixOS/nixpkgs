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
  version = "9.1.0";

  src = fetchFromGitHub {
    owner = "simdutf";
    repo = "simdutf";
    rev = "v${finalAttrs.version}";
    hash = "sha256-PKL495sfkRKjHfN4RroW1dwudJV2JWN7ogB8hyDxj5Y=";
  };

  cmakeFlags = [
    (lib.cmakeBool "BUILD_SHARED_LIBS" (!stdenv.hostPlatform.isStatic))

    # Enabling C++20 to get atomic support
    (lib.cmakeFeature "SIMDUTF_CXX_STANDARD" "20")
    (lib.cmakeBool "SIMDUTF_TESTS" finalAttrs.finalPackage.doCheck)
    (lib.cmakeBool "SIMDUTF_ATOMIC_BASE64_TESTS" finalAttrs.finalPackage.doCheck)
  ];

  nativeBuildInputs = [
    cmake
    validatePkgConfig
  ];

  buildInputs = [
    libiconv
  ];

  doCheck = true;

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
