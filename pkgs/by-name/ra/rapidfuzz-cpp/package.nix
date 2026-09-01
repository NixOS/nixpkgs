{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  catch2_3,
  python3Packages,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "rapidfuzz-cpp";
  version = "3.3.4";

  src = fetchFromGitHub {
    owner = "rapidfuzz";
    repo = "rapidfuzz-cpp";
    rev = "v${finalAttrs.version}";
    hash = "sha256-rfW4k6D0vrPwZ/6G9NuDLhZiyhr9s/tMo6a6t//Po04=";
  };

  nativeBuildInputs = [
    cmake
  ];

  cmakeFlags = lib.optionals finalAttrs.finalPackage.doCheck [
    "-DRAPIDFUZZ_BUILD_TESTING=ON"
  ];

  env = lib.optionalAttrs stdenv.cc.isClang {
    CXXFLAGS = toString [
      # error: no member named 'fill' in namespace 'std'
      "-include"
      "algorithm"
    ];
  };

  nativeCheckInputs = [
    catch2_3
  ];

  passthru = {
    tests = {
      /**
        `python3Packages.levenshtein` crucially depends on `rapidfuzz-cpp`
      */
      inherit (python3Packages) levenshtein;
    };
  };

  meta = {
    description = "Rapid fuzzy string matching in C++ using the Levenshtein Distance";
    homepage = "https://github.com/rapidfuzz/rapidfuzz-cpp";
    changelog = "https://github.com/rapidfuzz/rapidfuzz-cpp/blob/${finalAttrs.src.rev}/CHANGELOG.md";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ dotlambda ];
    platforms = lib.platforms.unix;
  };
})
