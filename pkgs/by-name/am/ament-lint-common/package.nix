{
  stdenv,

  python3Packages,

  ament-cmake-core,
  ament-cmake-export-dependencies,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "ament-lint-common";
  inherit (python3Packages.ament-lint) version src;

  sourceRoot = "${finalAttrs.src.name}/ament_lint_common/";

  inherit (ament-cmake-core) nativeBuildInputs;

  buildInputs = [
    ament-cmake-core
    ament-cmake-export-dependencies
  ];

  strictDeps = true;
  __structuredAttrs = true;

  meta = {
    inherit (python3Packages.ament-lint.meta)
      homepage
      license
      maintainers
      platforms
      ;
    description = "List of commonly used linters in the ament build system in CMake";
  };
})
