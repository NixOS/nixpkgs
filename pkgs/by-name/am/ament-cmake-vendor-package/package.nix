{
  stdenv,
  ament-cmake-core,

  ament-cmake-export-dependencies,
  ament-cmake-test,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "ament-cmake-vendor-package";
  inherit (ament-cmake-core) version src nativeBuildInputs;

  sourceRoot = "${finalAttrs.src.name}/ament_cmake_vendor_package";

  propagatedBuildInputs = [
    ament-cmake-core
    ament-cmake-export-dependencies
  ];

  doCheck = true;
  checkInputs = [ ament-cmake-test ];

  strictDeps = true;
  __structuredAttrs = true;

  meta = {
    inherit (ament-cmake-core.meta)
      homepage
      license
      maintainers
      platforms
      ;
    description = "Macros for maintaining a 'vendor' package";
  };
})
