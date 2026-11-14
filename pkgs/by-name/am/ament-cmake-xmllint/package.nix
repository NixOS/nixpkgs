{
  stdenv,

  python3Packages,

  ament-cmake-core,
  ament-cmake-test,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "ament-cmake-xmllint";
  inherit (python3Packages.ament-lint) version src;

  sourceRoot = "${finalAttrs.src.name}/ament_cmake_xmllint/";

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
    description = "CMake API for ament_xmllint to check XML file using xmmlint";
  };
})
