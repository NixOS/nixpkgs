{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  python3Packages,
}:
stdenv.mkDerivation (finalAttrs: {
  pname = "ament-cmake-core-jazzy";
  version = "2.5.4-1";

  src = fetchFromGitHub {
    owner = "ros2-gbp";
    repo = "ament_cmake-release";
    tag = "release/jazzy/ament_cmake_core/${finalAttrs.version}";
    hash = "sha256-e/6Vdq0lu3CHH3PySm6SbSDMa5iK7peJe8i/SA6mE4E=";
  };

  nativeBuildInputs = [
    python3Packages.ament-package
    cmake
    python3Packages.catkin-pkg
  ];

  meta = {
    description = "Core of the ament buildsystem in CMake";
    homepage = "https://github.com/ros2-gbp/ament_cmake-release/";
    license = lib.licenses.asl20;
    platforms = lib.platforms.all;
    maintainers = with lib.maintainers; [ guelakais ];
  };
})
