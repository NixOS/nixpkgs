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
    rev = "514b52ec61609744d7e587d93a7ef9b60407ab45";
    hash = "sha256-o+HD5OlxveeCr9M9Q00/8RHs6dhv8LOdjdA8drRKDoE=";
  };
in
stdenv.mkDerivation (finalAttrs: {
  pname = "spirv-tools";
  version = "1.4.335.0";

  src = fetchFromGitHub {
    owner = "KhronosGroup";
    repo = "SPIRV-Tools";
    rev = "vulkan-sdk-${finalAttrs.version}";
    hash = "sha256-H+t7ZH4SB+XgWTLj9XaJWZwAWk8M2QeC98Zi5ay8PBc=";
  };

  # The cmake options are sufficient for turning on static building, but not
  # for disabling shared building, just trim the shared lib from the CMake
  # description
  patches = lib.optional stdenv.hostPlatform.isStatic ./no-shared-libs.patch;

  nativeBuildInputs = [
    cmake
    python3
  ];

  nativeCheckInputs = [
    ctestCheckHook
  ];

  cmakeFlags = [
    "-DSPIRV-Headers_SOURCE_DIR=${spirv-headers.src}"
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

  postPatch =
    # https://github.com/KhronosGroup/SPIRV-Tools/issues/3905
    ''
      substituteInPlace CMakeLists.txt \
        --replace-fail '-P ''${CMAKE_CURRENT_SOURCE_DIR}/cmake/write_pkg_config.cmake' \
                       '-DCMAKE_INSTALL_FULL_LIBDIR=''${CMAKE_INSTALL_FULL_LIBDIR}
                       -DCMAKE_INSTALL_FULL_INCLUDEDIR=''${CMAKE_INSTALL_FULL_INCLUDEDIR}
                       -P ''${CMAKE_CURRENT_SOURCE_DIR}/cmake/write_pkg_config.cmake'
      substituteInPlace cmake/SPIRV-Tools.pc.in \
        --replace-fail '$'{prefix}/@CMAKE_INSTALL_LIBDIR@ @CMAKE_INSTALL_FULL_LIBDIR@ \
        --replace-fail '$'{prefix}/@CMAKE_INSTALL_INCLUDEDIR@ @CMAKE_INSTALL_FULL_INCLUDEDIR@
      substituteInPlace cmake/SPIRV-Tools-shared.pc.in \
        --replace-fail '$'{prefix}/@CMAKE_INSTALL_LIBDIR@ @CMAKE_INSTALL_FULL_LIBDIR@ \
        --replace-fail '$'{prefix}/@CMAKE_INSTALL_INCLUDEDIR@ @CMAKE_INSTALL_FULL_INCLUDEDIR@
    ''
    # Can't pass location via flags
    + lib.optionalString finalAttrs.finalPackage.doCheck ''
      ln -vs ${effcee-src} external/effcee
    '';

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
