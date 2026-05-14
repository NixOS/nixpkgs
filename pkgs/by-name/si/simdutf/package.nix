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
  version = "8.1.0";

  src = fetchFromGitHub {
    owner = "simdutf";
    repo = "simdutf";
    rev = "v${finalAttrs.version}";
    hash = "sha256-8a1J30guKz3ztZf5DGOaL7ZGVB0GpT5gtR1ZaAC4ucE=";
  };

  # Fix build on darwin
  postPatch = ''
    substituteInPlace tools/CMakeLists.txt --replace "-Wl,--gc-sections" ""
  '';

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
