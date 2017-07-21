{
  mkDerivation, lib,
  extra-cmake-modules, kdoctools,
  qtscript, kconfig, kinit, karchive,
  kcmutils, kconfigwidgets, knewstuff, kparts, qca-qt5,
  shared_mime_info
}:

mkDerivation {
  name = "okteta";
  meta = {
    license = with lib.licenses; [ gpl2 ];
    maintainers = with lib.maintainers; [ peterhoeg ];
  };
  nativeBuildInputs = [ qtscript extra-cmake-modules kdoctools ];
  buildInputs = [ shared_mime_info ];
  propagatedBuildInputs = [
    kconfig kinit kcmutils kconfigwidgets knewstuff kparts qca-qt5
    karchive
  ];
}
