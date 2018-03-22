{
  mkDerivation, lib,
  extra-cmake-modules, kdoctools,
  qtscript, kconfig, kinit, karchive, kcrash,
  kcmutils, kconfigwidgets, knewstuff, kparts, qca-qt5,
  shared-mime-info
}:

mkDerivation {
  name = "okteta";
  meta = {
    license = with lib.licenses; [ gpl2 ];
    maintainers = with lib.maintainers; [ peterhoeg ];
  };
  nativeBuildInputs = [ qtscript extra-cmake-modules kdoctools ];
  buildInputs = [ shared-mime-info ];
  propagatedBuildInputs = [
    kconfig kinit kcmutils kconfigwidgets knewstuff kparts qca-qt5
    karchive kcrash
  ];
}
