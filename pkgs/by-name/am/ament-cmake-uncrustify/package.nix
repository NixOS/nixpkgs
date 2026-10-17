{
  stdenv,

  python3Packages,

  ament-cmake-core,
  ament-cmake-test,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "ament-cmake-uncrustify";
  inherit (python3Packages.ament-lint) version src;

  sourceRoot = "${finalAttrs.src.name}/ament_cmake_uncrustify/";

  inherit (ament-cmake-core) nativeBuildInputs;

  buildInputs = [
    ament-cmake-core
    ament-cmake-test
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
    description = "CMake API for ament_uncrustify to check code against styleconventions using uncrustify";
  };
})
