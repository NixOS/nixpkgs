{
  stdenv,
  ament-cmake-core,
  gtest,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "ament-cmake-gtest";
  inherit (ament-cmake-core) version src nativeBuildInputs;

  sourceRoot = "${finalAttrs.src.name}/ament_cmake_gtest";

  propagatedBuildInputs = [
    ament-cmake-core
    gtest
  ];

  strictDeps = true;
  __structuredAttrs = true;

  meta = {
    inherit (ament-cmake-core.meta)
      homepage
      license
      maintainers
      platforms
      ;
    description = "Ability to add gtest-based tests in the ament buildsystem in CMake";
  };
})
