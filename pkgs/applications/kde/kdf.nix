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
  meta = with lib; {
    license = with licenses; [ gpl2 ];
    maintainers = [ maintainers.peterhoeg ];
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
