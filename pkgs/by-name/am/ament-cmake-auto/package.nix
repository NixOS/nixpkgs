{
  stdenv,
  ament-cmake-core,

  ament-cmake,
  ament-cmake-export-definitions,
  ament-cmake-export-include-directories,
  ament-cmake-export-libraries,
  ament-cmake-export-link-flags,
  ament-cmake-export-targets,
  ament-cmake-gen-version-h,
  ament-cmake-gmock,
  ament-cmake-gtest,
  ament-cmake-include-directories,
  ament-cmake-libraries,
  ament-cmake-python,
  ament-cmake-target-dependencies,
  ament-cmake-test,
  ament-cmake-version,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "ament-cmake-auto";
  inherit (ament-cmake-core) version src nativeBuildInputs;

  sourceRoot = "${finalAttrs.src.name}/ament_cmake_auto";

  propagatedBuildInputs = [
    ament-cmake
    ament-cmake-core
    ament-cmake-export-definitions
    ament-cmake-export-include-directories
    ament-cmake-export-libraries
    ament-cmake-export-link-flags
    ament-cmake-export-targets
    ament-cmake-gen-version-h
    ament-cmake-gmock
    ament-cmake-gtest
    ament-cmake-include-directories
    ament-cmake-libraries
    ament-cmake-python
    ament-cmake-target-dependencies
    ament-cmake-test
    ament-cmake-version
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
    description = "Auto-magic functions for ease to use of the ament buildsystem in CMake";
  };
})
