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
  version = "9.0.40";

  __structuredAttrs = true;
  strictDeps = true;
  separateDebugInfo = true;

  src = fetchFromGitHub {
    owner = "google";
    repo = "libphonenumber";
    tag = "v${finalAttrs.version}";
    hash = "sha256-YCHKHT/GjIzJZZ7HdXtkZtVbZh4TJcCqMLkoDXOzXFk=";
  };

  patches = [
    # An earlier version of this patch was submitted upstream but did not get
    # any interest there - https://github.com/google/libphonenumber/pull/2921
    ./build-reproducibility.patch
    # Fix include directory in generated cmake files with split outputs
    ./cmake-include-dir.patch
  ];

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

      BUILD_SHARED_LIBS = true;
      BUILD_STATIC_LIB = true;
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
