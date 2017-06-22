{
  mkDerivation, lib,
  extra-cmake-modules, kdoctools, shared_mime_info,
  kconfig, kinit, kcmutils, kconfigwidgets, knewstuff, kparts, qca-qt5, qtscript
}:

mkDerivation {
  name = "okteta";
  meta = {
    license = with lib.licenses; [ gpl2 ];
    maintainers = with lib.maintainers; [ peterhoeg ];
  };
  nativeBuildInputs = [ extra-cmake-modules kdoctools shared_mime_info ];
  buildInputs = [
    kconfig kinit kcmutils kconfigwidgets knewstuff kparts qca-qt5 qtscript
  ];
}
