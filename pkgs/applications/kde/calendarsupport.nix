{
  kdeApp, lib, kdeWrapper,
  extra-cmake-modules, kdoctools,
  akonadi, akonadi-calendar, akonadi-mime, kcalutils, kcompletion, kdepim-apps-libs, kholidays,
  kmime, kxmlgui, pimcommon
}:
kdeApp {
  name = "calendarsupport";
  meta = {
    license = with lib.licenses; [ gpl2 lgpl21 fdl12 ];
    maintainers = [ lib.maintainers.vandenoever ];
  };
  nativeBuildInputs = [ extra-cmake-modules kdoctools ];
  propagatedBuildInputs = [
    akonadi akonadi-calendar akonadi-mime kcalutils kcompletion kdepim-apps-libs kholidays kmime
    kxmlgui pimcommon
  ];
}
