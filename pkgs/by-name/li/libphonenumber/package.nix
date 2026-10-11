{
  lib,
  testers,
  stdenv,
  fetchFromGitHub,
  buildPackages,
  cmake,
  pkg-config,

  icu,
  protobuf,
  gtest,

  generateMetadata ? lib.meta.availableOn stdenv.buildPlatform jre,
  jre,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "libphonenumber";
  version = "9.0.41";

  __structuredAttrs = true;
  strictDeps = true;
  separateDebugInfo = true;

  src = fetchFromGitHub {
    owner = "google";
    repo = "libphonenumber";
    tag = "v${finalAttrs.version}";
    hash = "sha256-19Ty4yzDFN3EQsr20pWXcWvZNgPIs6m1Jb+emwzGNOg=";
  };

  patches = [
    # An earlier version of this patch was submitted upstream but did not get
    # any interest there - https://github.com/google/libphonenumber/pull/2921
    ./build-reproducibility.patch
    # Fix include directory in generated cmake files with split outputs
    ./cmake-include-dir.patch
  ];

  # Upstream compiles a test program which is hardcoded to link against the static versions of the compiled libraries.
  # Without this change, we can't disable building static libraries on non-static platforms.
  postPatch = lib.optionalString (!stdenv.hostPlatform.isStatic) ''
    substituteInPlace cpp/CMakeLists.txt \
      --replace-fail 'target_link_libraries (geocoding_test_program geocoding phonenumber)' 'target_link_libraries (geocoding_test_program geocoding-shared phonenumber-shared)'
  '';

  outputs = [
    "out"
    "dev"
  ];

  nativeBuildInputs = [
    cmake
    pkg-config
    protobuf
  ]
  ++ lib.optionals generateMetadata [
    jre
  ];

  buildInputs = [
    icu
  ];

  checkInputs = [
    gtest
  ];

  propagatedBuildInputs = [
    protobuf
  ];

  cmakeDir = "../cpp";

  doCheck = generateMetadata;

  checkTarget = "tests";

  cmakeFlags =
    assert lib.assertMsg (
      finalAttrs.finalPackage.doCheck -> generateMetadata
    ) "libphonenumber tests require generateMetadata to be true";
    lib.mapAttrsToList lib.cmakeBool {
      REGENERATE_METADATA = generateMetadata;

      BUILD_GEOCODER = true;
      USE_ALTERNATE_FORMATS = true;

      # Boost is only used for missing standard library features on legacy compilers
      # With modern libstdc++, we can simply prefer modern equivalents
      USE_BOOST = false;
      USE_ICU_REGEXP = true;
      USE_STDMUTEX = true;
      USE_STD_MAP = true;

      BUILD_SHARED_LIBS = !stdenv.hostPlatform.isStatic;
      BUILD_STATIC_LIB = stdenv.hostPlatform.isStatic;
    }
    ++ [
      (lib.cmakeFeature "CMAKE_CXX_FLAGS" "-Wno-error=deprecated-declarations")
    ]
    ++ lib.optionals (!stdenv.buildPlatform.canExecute stdenv.hostPlatform) [
      (lib.cmakeFeature "CMAKE_CROSSCOMPILING_EMULATOR" (stdenv.hostPlatform.emulator buildPackages))
      (lib.cmakeFeature "PROTOC_BIN" (lib.getExe buildPackages.protobuf))
    ];

  passthru.tests = {
    cmake-config = testers.hasCmakeConfigModules {
      package = finalAttrs.finalPackage;
      moduleNames = [ "libphonenumber" ];
    };
  };

  meta = {
    changelog = "https://github.com/google/libphonenumber/blob/${finalAttrs.src.tag}/release_notes.txt";
    description = "Google's i18n library for parsing and using phone numbers";
    homepage = "https://github.com/google/libphonenumber";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [
      illegalprime
      wegank
    ];
  };
})
