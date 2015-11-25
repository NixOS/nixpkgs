{ kdeApp
, lib
, extra-cmake-modules
, kdoctools
, kconfig
, kio
, ki18n
, kservice
, kfilemetadata
, baloo
, kdelibs4support
}:

kdeApp {
  name = "baloo-widgets";
  nativeBuildInputs = [
    extra-cmake-modules
    kdoctools
  ];
  buildInputs = [
    kconfig
    kservice
  ];
  propagatedBuildInputs = [
    baloo
    kdelibs4support
    kfilemetadata
    ki18n
    kio
  ];
  meta = {
    license = [ lib.licenses.lgpl21 ];
    maintainers = [ lib.maintainers.ttuegel ];
  };
}
