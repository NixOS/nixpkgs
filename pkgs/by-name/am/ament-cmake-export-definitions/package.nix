{
  stdenv,
  ament-cmake-core,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "ament-cmake-export-definitions";
  inherit (ament-cmake-core) version src nativeBuildInputs;

  sourceRoot = "${finalAttrs.src.name}/ament_cmake_export_definitions";

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
    description = "Ability to export definitions to downstream packages in the ament buildsystem";
  };
})
