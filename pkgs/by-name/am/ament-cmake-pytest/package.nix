{
  stdenv,
  ament-cmake-core,

  ament-cmake-test,
  python3Packages,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "ament-cmake-pytest";
  inherit (ament-cmake-core) version src nativeBuildInputs;

  sourceRoot = "${finalAttrs.src.name}/ament_cmake_pytest";

  propagatedBuildInputs = [
    ament-cmake-core
    ament-cmake-test
    python3Packages.pytest
  ];

  doCheck = true;

  strictDeps = true;
  __structuredAttrs = true;

  meta = {
    inherit (ament-cmake-core.meta)
      homepage
      license
      maintainers
      platforms
      ;
    description = "Ability to run Python tests using pytest in the ament buildsystem in CMake";
  };
})
