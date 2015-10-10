{ kdeApp
, lib
, extra-cmake-modules
, kdoctools
, karchive
, kconfig
, kcrash
, kdbusaddons
, ki18n
, kiconthemes
, khtml
, kio
, kservice
, kpty
, kwidgetsaddons
, libarchive
}:

kdeApp {
  name = "ark";
  nativeBuildInputs = [
    extra-cmake-modules
    kdoctools
  ];
  buildInputs = [
    karchive
    kconfig
    kcrash
    kdbusaddons
    kiconthemes
    kio
    kservice
    kpty
    kwidgetsaddons
    libarchive
  ];
  propagatedBuildInputs = [
    khtml
    ki18n
  ];
  meta = {
    license = with lib.licenses; [ gpl2 lgpl3 ];
    maintainers = [ lib.maintainers.ttuegel ];
  };
}
