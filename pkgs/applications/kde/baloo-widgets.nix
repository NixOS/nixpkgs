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
  meta = with lib; {
    license = [ licenses.lgpl21 ];
    maintainers = [ maintainers.ttuegel ];
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
