{
  mkDerivation,
  lib,
  extra-cmake-modules,
  kdoctools,
  baloo,
  kconfig,
  kfilemetadata,
  ki18n,
  kio,
  kservice,
}:

mkDerivation {
  pname = "baloo-widgets";
  meta = {
    license = [ lib.licenses.lgpl21 ];
    maintainers = [ lib.maintainers.ttuegel ];
  };
  nativeBuildInputs = [
    extra-cmake-modules
    kdoctools
  ];
  propagatedBuildInputs = [
    baloo
    kconfig
    kfilemetadata
    ki18n
    kio
    kservice
  ];
  outputs = [
    "out"
    "dev"
  ];
}
