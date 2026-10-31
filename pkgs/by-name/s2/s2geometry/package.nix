{
  abseil-cpp_202508,
  cmake,
  fetchFromGitHub,
  gbenchmark,
  gtest,
  stdenv,
  lib,
  pkg-config,
  openssl,
}:

let
  cxxStandard = "17";
in
stdenv.mkDerivation (finalAttrs: {
  pname = "s2geometry";
  version = "0.14.0";

  src = fetchFromGitHub {
    owner = "google";
    repo = "s2geometry";
    tag = "v${finalAttrs.version}";
    sha256 = "sha256-mdwxHgpnyyBX/hYiK43b8Qae5ffEZQZ9fVQlerX43VA=";
  };

  nativeBuildInputs = [
    cmake
    pkg-config
  ];

  cmakeFlags = [
    (lib.cmakeFeature "CMAKE_CXX_STANDARD" cxxStandard)
    (lib.cmakeBool "BUILD_TESTS" finalAttrs.finalPackage.doCheck)
    # The test suite downloads googletest and benchmark with FetchContent;
    # point it at the sources from nixpkgs instead.
    (lib.cmakeFeature "FETCHCONTENT_SOURCE_DIR_GOOGLETEST" "${gtest.src}")
    (lib.cmakeFeature "FETCHCONTENT_SOURCE_DIR_BENCHMARK" "${gbenchmark.src}")
    (lib.cmakeBool "INSTALL_GTEST" false)
  ];

  # OpenSSL is only used by the bignum test since 0.14.0.
  buildInputs = lib.optionals finalAttrs.finalPackage.doCheck [
    openssl
  ];

  propagatedBuildInputs = [
    # 0.13.0 and later require abseil-cpp LTS 20250814.
    (abseil-cpp_202508.override { inherit cxxStandard; })
  ];

  doCheck = true;

  # Only installed when tests are built; keep the output independent of doCheck.
  postInstall = lib.optionalString finalAttrs.finalPackage.doCheck ''
    rm $out/lib/libs2testing.a
  '';

  meta = {
    changelog = "https://github.com/google/s2geometry/releases/tag/v${finalAttrs.version}";
    description = "Computational geometry and spatial indexing on the sphere";
    homepage = "http://s2geometry.io/";
    license = lib.licenses.asl20;
    maintainers = [ lib.maintainers.Thra11 ];
    platforms = lib.platforms.unix;
  };
})
