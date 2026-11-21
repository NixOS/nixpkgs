{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  autoconf,
  automake,
  libtool,
  llvmPackages,
  gmp,
  ntl,
  nix-update-script,
  testers,
  withNtl ? false,
  withReducedNoise ? false,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "openfhe";
  version = "1.5.1";

  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "openfheorg";
    repo = "openfhe-development";
    tag = "v${finalAttrs.version}";
    fetchSubmodules = true;
    hash = "sha256-BBHhnn5uQEsoUDPwFhe32oRDs5xJqh/YyUD5nd+hfp8=";
  };

  postPatch = lib.optionalString stdenv.hostPlatform.isDarwin ''
    substituteInPlace CMakeLists.txt \
      --replace-fail '/opt/homebrew/opt/libomp/lib'     '${lib.getLib llvmPackages.openmp}/lib' \
      --replace-fail '/opt/homebrew/opt/libomp/include' '${lib.getDev llvmPackages.openmp}/include' \
      --replace-fail '/usr/local/opt/libomp/lib'        '${lib.getLib llvmPackages.openmp}/lib' \
      --replace-fail '/usr/local/opt/libomp/include'    '${lib.getDev llvmPackages.openmp}/include' \
      --replace-fail '/opt/local/lib/libomp'            '${lib.getLib llvmPackages.openmp}/lib' \
      --replace-fail '/opt/local/include/libomp'        '${lib.getDev llvmPackages.openmp}/include'
  '';

  strictDeps = true;

  nativeBuildInputs = [
    cmake
  ]
  # WITH_NTL=ON triggers an autoconf-version check in upstream's CMakeLists
  # (gated by `if(WITH_TCM OR WITH_NTL)`), so autotools must be present even
  # when linking against the system NTL.
  ++ lib.optionals withNtl [
    autoconf
    automake
    libtool
  ];

  buildInputs = lib.optionals withNtl [
    gmp
    ntl
  ];

  # OpenFHEConfig.cmake exports CMAKE_CXX_FLAGS (with OpenMP_CXX_FLAGS folded
  # in) to consumers, so libomp on darwin must propagate, not just build.
  propagatedBuildInputs = lib.optionals stdenv.hostPlatform.isDarwin [ llvmPackages.openmp ];

  cmakeFlags = [
    (lib.cmakeBool "BUILD_SHARED" true)
    (lib.cmakeBool "BUILD_STATIC" false)
    (lib.cmakeBool "BUILD_UNITTESTS" finalAttrs.doCheck)
    (lib.cmakeBool "BUILD_EXAMPLES" false)
    (lib.cmakeBool "BUILD_BENCHMARKS" false)
    (lib.cmakeBool "WITH_OPENMP" true)
    (lib.cmakeBool "WITH_NATIVEOPT" false)
    (lib.cmakeBool "WITH_NTL" withNtl)
    (lib.cmakeBool "WITH_REDUCED_NOISE" withReducedNoise)
    (lib.cmakeFeature "MATHBACKEND" (if withNtl then "6" else "4"))
    (lib.cmakeFeature "INSTALL_CMAKE_DIR" "lib/cmake/OpenFHE")
  ];

  doCheck = stdenv.buildPlatform.canExecute stdenv.hostPlatform;

  checkPhase = ''
    runHook preCheck
    echo "=== core_tests ==="
    unittest/core_tests -t
    echo "=== pke_tests ==="
    unittest/pke_tests -t
    echo "=== binfhe_tests ==="
    unittest/binfhe_tests -t
    runHook postCheck
  '';

  passthru = {
    tests.cmake-config = testers.hasCmakeConfigModules {
      package = finalAttrs.finalPackage;
      moduleNames = [ "OpenFHE" ];
    };
    updateScript = nix-update-script { };
  };

  meta = {
    description = "Open-source library for fully homomorphic encryption (FHE)";
    homepage = "https://www.openfhe.org/";
    changelog = "https://github.com/openfheorg/openfhe-development/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.bsd2;
    maintainers = with lib.maintainers; [ ryanorendorff ];
    platforms = lib.platforms.linux ++ lib.platforms.darwin;
  };
})
