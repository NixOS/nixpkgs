{
  stdenv,
  ament-cmake-core,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "ament-cmake-include-directories";
  inherit (ament-cmake-core) version src nativeBuildInputs;

  sourceRoot = "${finalAttrs.src.name}/ament_cmake_include_directories";

  propagatedBuildInputs = [
    ament-cmake-core
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
    description = "Functionality to order include directories according to a chain of prefixes in the ament buildsystem in CMake";
  };
})
