{
  kdeApp, lib,
  extra-cmake-modules, kdoctools,
  akonadi, kcompletion, kmime, kxmlgui
}:

kdeApp {
  name = "akonadi-notes";
  meta = {
    license = with lib.licenses; [ gpl2 lgpl21 fdl12 ];
    maintainers = [ lib.maintainers.vandenoever ];
  };
  nativeBuildInputs = [ extra-cmake-modules kdoctools ];
  propagatedBuildInputs = [
    akonadi kcompletion kmime kxmlgui
  ];
}
