{
  mkDerivation, lib,
  extra-cmake-modules, kdoctools, wrapGAppsHook,
  kconfig, kinit,
  kcmutils, kconfigwidgets, knewstuff, kparts, qca-qt5
}:

mkDerivation {
  name = "okteta";
  meta = {
    license = with lib.licenses; [ gpl2 ];
    maintainers = with lib.maintainers; [ peterhoeg ];
  };
  nativeBuildInputs = [ extra-cmake-modules kdoctools wrapGAppsHook ];
  propagatedBuildInputs = [
    kconfig kinit
    kcmutils kconfigwidgets knewstuff kparts qca-qt5
  ];
}
