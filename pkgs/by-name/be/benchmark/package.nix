{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  gtest,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "benchmark";
  version = "1.9.4";

  src = fetchFromGitHub {
    owner = "google";
    repo = "benchmark";
    rev = "v${finalAttrs.version}";
    hash = "sha256-P7wJcKkIBoWtN9FCRticpBzYbEZPq71a0iW/2oDTZRU=";
  };

  nativeBuildInputs = [ cmake ];
  buildInputs = [ gtest ];

  cmakeFlags = [
    "-DBENCHMARK_USE_BUNDLED_GTEST=OFF"
    "-DBENCHMARK_ENABLE_GTEST_TESTS=OFF"
    "-DBENCHMARK_ENABLE_TESTING=OFF"
    "-DBENCHMARK_DOWNLOAD_DEPENDENCIES=OFF"
  ];

  meta = {
    description = "A microbenchmark support library";
    downloadPage = "https://github.com/google/benchmark";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ guelakais ];
    platforms = lib.platforms.all;
  };
})
