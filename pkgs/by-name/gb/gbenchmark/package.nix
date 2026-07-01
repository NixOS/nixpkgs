{
  lib,
  stdenv,
  fetchFromGitHub,
  fetchpatch,
  cmake,
  ninja,
  gtest,
  glibcLocales,
  prometheus-cpp,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "gbenchmark";
  version = "1.9.5";

  src = fetchFromGitHub {
    owner = "google";
    repo = "benchmark";
    tag = "v${finalAttrs.version}";
    hash = "sha256-Mm4pG7zMB00iof32CxreoNBFnduPZTMp3reHMCIAFPQ=";
  };

  patches = [
    (fetchpatch {
      name = "portability.patch";
      url = "https://github.com/google/benchmark/commit/b5ba9bab85d80f29a161dd634b7d234cf3722f90.patch";
      hash = "sha256-/X01AWXK0eJ59F8oSREZ7V5Cpw1y35n9uFB1mCvMOus=";
    })
  ];

  nativeBuildInputs = [
    cmake
    ninja
  ];

  buildInputs = [ gtest ];

  nativeCheckInputs = lib.optionals (glibcLocales != null) [ glibcLocales ];

  cmakeFlags = [
    (lib.cmakeBool "BENCHMARK_USE_BUNDLED_GTEST" false)
    (lib.cmakeBool "BENCHMARK_ENABLE_WERROR" false)
  ];

  env = {
    # We ran into issues with gtest 1.8.5 conditioning on
    # `#if __has_cpp_attribute(maybe_unused)`, which was, for some
    # reason, going through even when C++14 was being used and
    # breaking the build on Darwin by triggering errors about using
    # C++17 features.
    #
    # This might be a problem with our Clang, as it does not reproduce
    # with Xcode, but we just work around it by silencing the warning.
    NIX_CFLAGS_COMPILE = lib.join " " (
      [
        "-Wno-error=c2y-extensions"
      ]
      ++ lib.optional stdenv.cc.isClang "-Wno-c++17-attribute-extensions"
    );
  }
  // lib.optionalAttrs stdenv.hostPlatform.isGnu {
    # For test:locale_impermeability_test
    LANG = "en_US.UTF-8";
    LC_ALL = "en_US.UTF-8";
  }
  // lib.optionalAttrs (glibcLocales != null) {
    LOCALE_ARCHIVE = "${glibcLocales}/lib/locale/locale-archive";
  };

  # Tests fail on 32-bit due to not enough precision
  doCheck = stdenv.hostPlatform.is64bit;

  passthru.tests = {
    inherit prometheus-cpp;
  };

  meta = {
    description = "Microbenchmark support library";
    homepage = "https://github.com/google/benchmark";
    license = lib.licenses.asl20;
    platforms = lib.platforms.linux ++ lib.platforms.darwin ++ lib.platforms.freebsd;
    maintainers = with lib.maintainers; [ miniharinn ];
  };
})
