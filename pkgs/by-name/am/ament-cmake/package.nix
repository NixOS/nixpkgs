{
  stdenv,
  ament-cmake-core,
  ament-cmake-export-dependencies,
}:
stdenv.mkDerivation (finalAttrs: {
  pname = "ament-cmake";
  inherit (ament-cmake-core) version src nativeBuildInputs;

  sourceRoot = "${finalAttrs.src.name}/ament_cmake";

  propagatedBuildInputs = [
    ament-cmake-core
    ament-cmake-export-dependencies
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
    description = "The entry point package for the ament buildsystem in CMake";
  };
})
