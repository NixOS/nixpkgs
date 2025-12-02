{
  abseil-cpp_202407,
  cmake,
  fetchFromGitHub,
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
  version = "0.12.0";

  src = fetchFromGitHub {
    owner = "google";
    repo = "s2geometry";
    tag = "v${finalAttrs.version}";
    sha256 = "sha256-stH1iO4AEL+VZizntUzhvADNOKX333o3QSOz+WOBZ5Q=";
  };

  nativeBuildInputs = [
    cmake
    pkg-config
  ];

  cmakeFlags = [
    (lib.cmakeFeature "CMAKE_CXX_STANDARD" cxxStandard)
    # incompatible with our version of gtest
    (lib.cmakeBool "BUILD_TESTS" false)
  ];

  buildInputs = [
    openssl
  ];

  propagatedBuildInputs = [
    (abseil-cpp_202407.override { inherit cxxStandard; })
  ];

  meta = with lib; {
    changelog = "https://github.com/google/s2geometry/releases/tag/v${finalAttrs.version}";
    description = "Computational geometry and spatial indexing on the sphere";
    homepage = "http://s2geometry.io/";
    license = licenses.asl20;
    maintainers = [ maintainers.Thra11 ];
    platforms = platforms.unix;
  };
})
