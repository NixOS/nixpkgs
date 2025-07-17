{
  mkDerivation,
  lib,
  extra-cmake-modules,
  kdoctools,
  kcmutils,
  ki18n,
  kiconthemes,
  kio,
  knotifications,
  kxmlgui,
}:

mkDerivation {
  pname = "kdf";
  meta = {
    license = with lib.licenses; [ gpl2 ];
    maintainers = [ lib.maintainers.peterhoeg ];
  };
  nativeBuildInputs = [
    extra-cmake-modules
    kdoctools
  ];
  buildInputs = [
    kcmutils
    ki18n
    kiconthemes
    kio
    knotifications
    kxmlgui
  ];
}
