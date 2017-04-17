{
  kdeApp, lib,
  extra-cmake-modules, kdoctools,
  akonadi, kcompletion, kidentitymanagement, kio, kmailtransport, kxmlgui,
  pimcommon, qtwebengine
}:
kdeApp {
  name = "libksieve";
  meta = {
    license = with lib.licenses; [ gpl2 lgpl21 fdl12 ];
    maintainers = [ lib.maintainers.vandenoever ];
  };
  nativeBuildInputs = [ extra-cmake-modules kdoctools ];
  propagatedBuildInputs = [
    akonadi kcompletion kidentitymanagement kio kmailtransport kxmlgui pimcommon
    qtwebengine
  ];
}
