{
  stdenv,

  python3Packages,

  ament-cmake-core,
  ament-cmake-test,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "ament-cmake-cpplint";
  inherit (python3Packages.ament-lint) version src;

  sourceRoot = "${finalAttrs.src.name}/ament_cmake_cpplint/";

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
    description = "CMake API for ament_cpplint to lint C / C++ code using cpplint";
  };
})
