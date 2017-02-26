{
  kdeApp, lib,
  extra-cmake-modules, kdoctools,
  baloo, kconfig, kdelibs4support, kfilemetadata, ki18n, kio, kservice
}:

kdeApp {
  name = "baloo-widgets";
  meta = {
    license = [ lib.licenses.lgpl21 ];
    maintainers = [ lib.maintainers.ttuegel ];
  };
  nativeBuildInputs = [ extra-cmake-modules kdoctools ];
  propagatedBuildInputs = [
    baloo kconfig kdelibs4support kfilemetadata ki18n kio kservice
  ];
}
