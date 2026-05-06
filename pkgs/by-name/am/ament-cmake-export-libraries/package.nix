{
  stdenv,
  ament-cmake-core,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "ament-cmake-export-libraries";
  inherit (ament-cmake-core) version src nativeBuildInputs;

  sourceRoot = "${finalAttrs.src.name}/ament_cmake_export_libraries";

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
    description = "Ability to export libraries to downstream packages in the ament buildsystem in CMake";
  };
})
