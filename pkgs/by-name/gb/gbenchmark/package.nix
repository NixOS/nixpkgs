{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  ninja,
  gtest,
  prometheus-cpp,
}:

stdenv.mkDerivation rec {
  pname = "gbenchmark";
  version = "1.9.4";

  src = fetchFromGitHub {
    owner = "google";
    repo = "benchmark";
    rev = "v${version}";
    hash = "sha256-P7wJcKkIBoWtN9FCRticpBzYbEZPq71a0iW/2oDTZRU=";
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
  env.NIX_CFLAGS_COMPILE = lib.optionalString stdenv.cc.isClang "-Wno-c++17-attribute-extensions";

  # Tests fail on 32-bit due to not enough precision
  doCheck = stdenv.hostPlatform.is64bit;

  passthru.tests = {
    inherit prometheus-cpp;
  };

  meta = with lib; {
    description = "Microbenchmark support library";
    homepage = "https://github.com/google/benchmark";
    license = licenses.asl20;
    platforms = platforms.linux ++ platforms.darwin ++ platforms.freebsd;
    maintainers = [ ];
  };
}
