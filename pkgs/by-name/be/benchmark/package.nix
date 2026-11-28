{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  gtest,
  testers,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "benchmark";
  version = "1.10.0";

  src = fetchFromGitHub {
    owner = "google";
    repo = "benchmark";
    tag = "v${finalAttrs.version}";
    hash = "sha256-yJzrkJxJUtCXmBJK474mu4MHJTT6ZnNnBRNwuCkRHEo=";
  };

  __structuredAttrs = true;

  nativeBuildInputs = [ cmake ];
  buildInputs = [ gtest ];

  cmakeFlags = [
    "-DBENCHMARK_USE_BUNDLED_GTEST=OFF"
    "-DBENCHMARK_ENABLE_GTEST_TESTS=OFF"
    "-DBENCHMARK_ENABLE_TESTING=OFF"
    "-DBENCHMARK_DOWNLOAD_DEPENDENCIES=OFF"
  ];

  strictDeps = true;

  passthru.tests.pkg-config = testers.hasPkgConfigModules {
    package = finalAttrs.finalPackage;
  };

  meta = {
    description = "A microbenchmark support library";
    downloadPage = "https://github.com/google/benchmark";
    homepage = "https://github.com/google/benchmark/blob/main/docs/user_guide.md";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ guelakais ];
    platforms = lib.platforms.all;
  };
})
