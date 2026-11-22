{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  fixDarwinDylibNames,
  gtest,
  static ? stdenv.hostPlatform.isStatic,
  cxxStandard ? null,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "abseil-cpp";
  version = "20260817.0";

  src = fetchFromGitHub {
    owner = "abseil";
    repo = "abseil-cpp";
    tag = finalAttrs.version;
    hash = "sha256-CEtLO4il9/jk+bFDDV0rXeX1OkirA0u6nxrSiWq0NPM=";
  };

  outputs = [
    "out"
    "dev"
    # Test helper libraries linking against GoogleTest
    "testing"
  ];

  cmakeFlags = [
    (lib.cmakeBool "ABSL_BUILD_TEST_HELPERS" true)
    (lib.cmakeBool "ABSL_USE_EXTERNAL_GOOGLETEST" true)
    (lib.cmakeBool "BUILD_SHARED_LIBS" (!static))
  ]
  ++ lib.optionals (cxxStandard != null) [
    (lib.cmakeFeature "CMAKE_CXX_STANDARD" cxxStandard)
  ];

  strictDeps = true;

  nativeBuildInputs = [ cmake ] ++ lib.optionals stdenv.hostPlatform.isDarwin [ fixDarwinDylibNames ];

  buildInputs = [ gtest ];

  postInstall = ''
    for lib in scoped_mock_log status_matchers; do
      moveToOutput "lib/libabsl_$lib.*" "$testing"
      substituteInPlace $out/lib/cmake/absl/abslTargets-*.cmake \
        --replace-fail "$out/lib/libabsl_$lib." "$testing/lib/libabsl_$lib."
      substituteInPlace "$out/lib/pkgconfig/absl_$lib.pc" \
        --replace-fail "libdir=$out/lib" "libdir=$testing/lib"
    done
  '';

  outputChecks.out.disallowedRequisites = [ gtest ];

  __structuredAttrs = true;

  meta = {
    description = "Open-source collection of C++ code designed to augment the C++ standard library";
    homepage = "https://abseil.io/";
    changelog = "https://github.com/abseil/abseil-cpp/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.asl20;
    platforms = lib.platforms.all;
    maintainers = [ lib.maintainers.GaetanLepage ];
  };
})
