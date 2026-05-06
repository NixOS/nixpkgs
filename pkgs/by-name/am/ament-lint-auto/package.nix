{
  stdenv,

  python3Packages,

  ament-cmake-core,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "ament-lint-auto";
  inherit (python3Packages.ament-lint) version src;

  sourceRoot = "${finalAttrs.src.name}/ament_lint_auto";

  inherit (ament-cmake-core) nativeBuildInputs;

  buildInputs = [ ament-cmake-core ];

  strictDeps = true;
  __structuredAttrs = true;

  meta = {
    inherit (python3Packages.ament-lint.meta)
      homepage
      license
      maintainers
      platforms
      ;
    description = "Auto-magic functions for ease to use of the ament linters in CMake";
  };
})
