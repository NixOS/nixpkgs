{
  python3Packages,
  ament-cmake-core,

  ament-cmake-export-dependencies,
  ament-cmake-python,
}:

python3Packages.buildPythonApplication (finalAttrs: {
  pname = "ament-cmake-google-benchmark";
  pyproject = false; # cmake

  inherit (ament-cmake-core) version src nativeBuildInputs;

  sourceRoot = "${finalAttrs.src.name}/ament_cmake_google_benchmark";

  propagatedBuildInputs = [
    ament-cmake-core
    ament-cmake-export-dependencies
    ament-cmake-python
  ];

  nativeCheckInputs = [ python3Packages.pythonImportsCheckHook ];
  pythonImportsCheck = [ "ament_cmake_google_benchmark" ];

  strictDeps = true;
  __structuredAttrs = true;

  meta = {
    inherit (ament-cmake-core.meta)
      homepage
      license
      maintainers
      platforms
      ;
    description = "Ability to add Google Benchmark tests in the ament buildsystem in CMake";
  };
})
