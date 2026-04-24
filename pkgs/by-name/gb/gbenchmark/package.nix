{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  ninja,
  gtest,
  prometheus-cpp,
  glibcLocales,
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

  nativeBuildInputs = [
    cmake
    ninja
  ];

  buildInputs = [ gtest ];

  cmakeFlags = [
    (lib.cmakeBool "BENCHMARK_USE_BUNDLED_GTEST" false)
    (lib.cmakeBool "BENCHMARK_ENABLE_WERROR" false)
  ];

  # We ran into issues with gtest 1.8.5 conditioning on
  # `#if __has_cpp_attribute(maybe_unused)`, which was, for some
  # reason, going through even when C++14 was being used and
  # breaking the build on Darwin by triggering errors about using
  # C++17 features.
  #
  # This might be a problem with our Clang, as it does not reproduce
  # with Xcode, but we just work around it by silencing the warning.
  env = {
    NIX_CFLAGS_COMPILE = lib.optionalString stdenv.cc.isClang "-Wno-c++17-attribute-extensions";
  }
  // lib.optionalAttrs (stdenv.hostPlatform.isLinux && stdenv.hostPlatform.isGnu) {
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
    maintainers = [ ];
  };
})
