{
  abseil-cpp,
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
  version = "0.11.1";

  src = fetchFromGitHub {
    owner = "google";
    repo = "s2geometry";
    rev = "refs/tags/v${finalAttrs.version}";
    sha256 = "sha256-VjgGcGgQlKmjUq+JU0JpyhOZ9pqwPcBUFEPGV9XoHc0=";
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
    (abseil-cpp.override { inherit cxxStandard; })
  ];

  meta = with lib; {
    changelog = "https://github.com/google/s2geometry/releases/tag/${lib.removePrefix "refs/tags/" finalAttrs.src.rev}";
    description = "Computational geometry and spatial indexing on the sphere";
    homepage = "http://s2geometry.io/";
    license = licenses.asl20;
    maintainers = [ maintainers.Thra11 ];
    platforms = platforms.unix;
  };
})
