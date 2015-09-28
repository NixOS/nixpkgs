{ mkDerivation
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

mkDerivation {
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
    ki18n
    kiconthemes
    khtml
    kio
    kservice
    kpty
    kwidgetsaddons
    libarchive
  ];
  meta = {
    license = with lib.licenses; [ gpl2 lgpl3 ];
    maintainers = [ lib.maintainers.ttuegel ];
  };
}
