{
  lib,
  stdenv,
  fetchFromGitHub,
  fetchpatch2,
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
    tag = "v${finalAttrs.version}";
    hash = "sha256-PKL495sfkRKjHfN4RroW1dwudJV2JWN7ogB8hyDxj5Y=";
  };

  # https://github.com/simdutf/simdutf/issues/1032
  # FIXME: remove in next release
  patches = lib.optionals (stdenv.hostPlatform.isLoongArch64 && finalAttrs.version == "9.1.0") [
    (fetchpatch2 {
      url = "https://github.com/simdutf/simdutf/commit/1f8ef080486c31cbd70db21a05a008700eb03aae.patch?full_index=1";
      hash = "sha256-p1qJFUQ4KhSSLSBIiC9se/TxrWFqywdVKNgh78TkMyE=";
    })
  ];

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

  strictDeps = true;

  doCheck = true;

  passthru = {
    updateScript = nix-update-script { };

    tests.pkg-config = testers.hasPkgConfigModules {
      package = finalAttrs.finalPackage;
    };
  };

  __structuredAttrs = true;

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
