{
  lib,
  stdenv,
  fetchFromGitHub,
  fetchpatch2,
  cmake,
  fast-float,
  gtest,
  nix-update-script,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "scnlib";
  version = "4.0.1";

  outputs = [
    "out"
    "dev"
  ];

  src = fetchFromGitHub {
    owner = "eliaskosunen";
    repo = "scnlib";
    tag = "v${finalAttrs.version}";
    hash = "sha256-qEZAWhtvhKMkh7fk1yD17ErWGCpztEs0seV4AkBOy1I=";
  };

  patches = [
    # Fix build against fast_float >= 7 (chars_format became an enum class)
    # https://github.com/eliaskosunen/scnlib/commit/144a590f6c7861101579069e89dfb1db0ddfec25
    (fetchpatch2 {
      name = "scnlib-fix-newer-fast-float.patch";
      url = "https://github.com/eliaskosunen/scnlib/commit/144a590f6c7861101579069e89dfb1db0ddfec25.patch?full_index=1";
      includes = [ "src/scn/impl.cpp" ];
      hash = "sha256-Z2or3xiu3NHHvgnO9Jen7yCv921Ls4SRPQ1URQPc3yQ=";
    })
  ];

  __structuredAttrs = true;
  strictDeps = true;

  nativeBuildInputs = [ cmake ];

  # scn-config.cmake calls find_dependency(FastFloat)
  propagatedBuildInputs = [ fast-float ];

  checkInputs = [ gtest ];

  cmakeFlags = [
    (lib.cmakeBool "BUILD_SHARED_LIBS" (!stdenv.hostPlatform.isStatic))
    (lib.cmakeBool "SCN_INSTALL" true)
    (lib.cmakeBool "SCN_TESTS" finalAttrs.finalPackage.doCheck)
    (lib.cmakeBool "SCN_EXAMPLES" false)
    (lib.cmakeBool "SCN_DOCS" false)
    (lib.cmakeBool "SCN_BENCHMARKS" false)
    (lib.cmakeBool "SCN_BENCHMARKS_BUILDTIME" false)
    (lib.cmakeBool "SCN_BENCHMARKS_BINARYSIZE" false)
    (lib.cmakeBool "SCN_PEDANTIC" false)
    (lib.cmakeBool "SCN_USE_EXTERNAL_FAST_FLOAT" true)
    (lib.cmakeBool "SCN_USE_EXTERNAL_GTEST" true)
  ];

  doCheck = true;

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Modern C++ library for replacing scanf and std::istream";
    homepage = "https://scnlib.dev";
    changelog = "https://github.com/eliaskosunen/scnlib/blob/${finalAttrs.src.tag}/CHANGELOG.md";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ grahamnorris ];
    platforms = lib.platforms.all;
  };
})
