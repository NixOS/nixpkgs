{
  python3Packages,
  ament-cmake-core,

  ament-cmake-python,
}:

python3Packages.buildPythonApplication (finalAttrs: {
  pname = "ament-cmake-test";
  pyproject = false; # cmake

  inherit (ament-cmake-core) version src nativeBuildInputs;

  sourceRoot = "${finalAttrs.src.name}/ament_cmake_test";

  propagatedBuildInputs = [
    ament-cmake-core
    ament-cmake-python
  ];

  nativeCheckInputs = [ python3Packages.pythonImportsCheckHook ];
  pythonImportsCheck = [ "ament_cmake_test" ];

  strictDeps = true;
  __structuredAttrs = true;

  meta = {
    inherit (ament-cmake-core.meta)
      homepage
      license
      maintainers
      platforms
      ;
    description = "Ability to add tests in the ament buildsystem in CMake";
  };
})
