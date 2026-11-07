{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  python3,
}:

let
  python = python3.withPackages (ps: [
    ps.ament-package
    ps.catkin-pkg
    ps.setuptools
  ]);
in

stdenv.mkDerivation (finalAttrs: {
  pname = "ament-cmake-core";
  version = "2.9.0";

  src = fetchFromGitHub {
    owner = "ament";
    repo = "ament_cmake";
    tag = finalAttrs.version;
    hash = "sha256-voT1D5oYs+fPO1subbqS59M5j1tpcsUkEzXvTZ5Ej4U=";
  };
  sourceRoot = "${finalAttrs.src.name}/ament_cmake_core";

  nativeBuildInputs = [
    cmake
    python
  ];

  strictDeps = true;
  __structuredAttrs = true;

  meta = {
    description = "Core of the ament buildsystem in CMake";
    homepage = "https://github.com/ament/ament_cmake";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ nim65s ];
    platforms = lib.platforms.all;
  };
})
