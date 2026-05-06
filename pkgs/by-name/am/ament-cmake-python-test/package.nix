{
  lib,
  stdenv,
  ament-cmake-core,

  ament-cmake-pytest,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "ament-cmake-python-test";
  inherit (ament-cmake-core) version src nativeBuildInputs;

  sourceRoot = "${finalAttrs.src.name}/ament_cmake_python_test";

  propagatedBuildInputs = [
    ament-cmake-core
  ];

  doInstallCheck = true;
  cmakeFlags = [ (lib.cmakeBool "BUILD_TESTING" finalAttrs.doInstallCheck) ];
  installCheckInputs = [ ament-cmake-pytest ];
  installCheckTarget = "test";

  strictDeps = true;
  __structuredAttrs = true;

  meta = {
    inherit (ament-cmake-core.meta)
      homepage
      license
      maintainers
      platforms
      ;
    description = "Test package for ament_cmake_python";
  };
})
