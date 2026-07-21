{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  eigen,
  boost,
  libnabo,
  yaml-cpp,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "libpointmatcher";
  version = "1.4.4";

  src = fetchFromGitHub {
    owner = "norlab-ulaval";
    repo = "libpointmatcher";
    tag = finalAttrs.version;
    hash = "sha256-OkfWdim0JDKiBx5spYpkMyFrLQP3AMWBVDpzmFwqNFM=";
  };

  # Fix boost 1.89 compatibility
  postPatch = ''
    substituteInPlace CMakeLists.txt \
      --replace-fail \
        "find_package(Boost REQUIRED COMPONENTS thread system program_options date_time)" \
        "find_package(Boost REQUIRED COMPONENTS thread program_options date_time)" \
      --replace-fail \
        "find_package(Boost REQUIRED COMPONENTS thread system program_options date_time chrono)" \
        "find_package(Boost REQUIRED COMPONENTS thread program_options date_time chrono)"

    substituteInPlace libpointmatcherConfig.cmake.in \
      --replace-fail \
        "find_package(Boost COMPONENTS thread system program_options date_time REQUIRED)" \
        "find_package(Boost COMPONENTS thread program_options date_time REQUIRED)" \
      --replace-fail \
        "find_package(Boost COMPONENTS thread system program_options date_time chrono REQUIRED)" \
        "find_package(Boost COMPONENTS thread program_options date_time chrono REQUIRED)"
  '';

  nativeBuildInputs = [ cmake ];
  buildInputs = [
    eigen
    boost
    libnabo
    yaml-cpp
  ];

  cmakeFlags = [
    (lib.cmakeFeature "EIGEN_INCLUDE_DIR" "${eigen}/include/eigen3")
    (lib.cmakeBool "BUILD_TESTS" finalAttrs.doCheck)
  ];

  doCheck = true;

  meta = {
    inherit (finalAttrs.src.meta) homepage;
    description = "\"Iterative Closest Point\" library for 2-D/3-D mapping in robotic";
    license = lib.licenses.bsd3;
    platforms = lib.platforms.linux;
    maintainers = with lib.maintainers; [ cryptix ];
  };
})
