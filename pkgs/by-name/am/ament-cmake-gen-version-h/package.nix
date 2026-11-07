{
  stdenv,
  ament-cmake-core,

  ament-cmake-gtest,
  ament-cmake-test,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "ament-cmake-gen-version-h";
  inherit (ament-cmake-core) version src nativeBuildInputs;

  sourceRoot = "${finalAttrs.src.name}/ament_cmake_gen_version_h";

  propagatedBuildInputs = [
    ament-cmake-core
  ];

  doCheck = true;

  checkInputs = [
    ament-cmake-gtest
    ament-cmake-test
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
    description = "Generate a C header containing the version number of the package";
  };
})
