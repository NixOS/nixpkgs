{
  lib,
  stdenv,
  fetchFromGitHub,
  abseil-cpp,
  cmake,
  ctestCheckHook,
  gtest,
  python3,
  re2,
  spirv-headers,
}:

let
  effcee-src = fetchFromGitHub {
    owner = "google";
    repo = "effcee";
    rev = "ae38e040cbb7e83efa8bfbb4967e5b8c8c89b55a";
    hash = "sha256-Ub5cyr6Wi+rbZ/Fs7JVilo9mhsj/SSS/hkqzQboXPCM=";
  };
in
stdenv.mkDerivation (finalAttrs: {
  pname = "spirv-tools";
  version = "1.4.341.0";

  src = fetchFromGitHub {
    owner = "KhronosGroup";
    repo = "SPIRV-Tools";
    rev = "vulkan-sdk-${finalAttrs.version}";
    hash = "sha256-8haVqfmTBvNuv5jEc/LaAO34pWjTZAJ04FIxuxfJNUc=";
  };

  patches = [
    # https://github.com/KhronosGroup/SPIRV-Tools/pull/6483
    ./0001-Fix-generated-pkg-config-modules-with-absolute-insta.patch
  ]
  # The cmake options are sufficient for turning on static building, but not
  # for disabling shared building, just trim the shared lib from the CMake
  # description
  ++ lib.optional stdenv.hostPlatform.isStatic ./no-shared-libs.patch;

  # Can't pass this location via flags
  postPatch = lib.optionalString finalAttrs.finalPackage.doCheck ''
    ln -vs ${effcee-src} external/effcee
  '';

  outputs = [
    "out"
    "lib"
    "dev"
  ];

  nativeBuildInputs = [
    cmake
    python3
  ];

  nativeCheckInputs = [
    ctestCheckHook
  ];

  cmakeFlags = [
    "-DSPIRV-Headers_SOURCE_DIR=${spirv-headers}"
    # Avoid blanket -Werror to evade build failures on less
    # tested compilers.
    "-DSPIRV_WERROR=OFF"
    (lib.cmakeBool "SPIRV_SKIP_TESTS" (!finalAttrs.finalPackage.doCheck))
  ]
  ++ lib.optionals finalAttrs.finalPackage.doCheck [
    (lib.cmakeFeature "absl_SOURCE_DIR" "${abseil-cpp.src}")
    (lib.cmakeFeature "GMOCK_DIR" "${gtest.src}")
    (lib.cmakeFeature "RE2_SOURCE_DIR" "${re2.src}")
  ];

  doCheck = stdenv.buildPlatform.canExecute stdenv.hostPlatform;

  disabledTests = lib.optionals (!stdenv.hostPlatform.isLittleEndian) [
    # TODO Report.
    # TODO Submit patch to make these tests report the actual strings, instead of just if they match, to better show the issue.
    # Looks similar to issues in glslang: strings are reversed in 4-byte chunks
    "spirv-tools-test_spirv_unit_test_tools_objdump"
  ];

  meta = {
    description = "SPIR-V Tools project provides an API and commands for processing SPIR-V modules";
    homepage = "https://github.com/KhronosGroup/SPIRV-Tools";
    license = lib.licenses.asl20;
    platforms = with lib.platforms; unix ++ windows;
    maintainers = [ lib.maintainers.ralith ];
  };
})
