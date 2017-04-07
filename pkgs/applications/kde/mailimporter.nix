{
  kdeApp, lib, kdeWrapper,
  extra-cmake-modules, kdoctools,
  akonadi, akonadi-mime, kcompletion, kconfig, kcoreaddons, kmime, kxmlgui,
  libkdepim
}:
kdeApp {
  name = "mailimporter";
  meta = {
    license = with lib.licenses; [ gpl2 lgpl21 fdl12 ];
    maintainers = [ lib.maintainers.vandenoever ];
  };
  nativeBuildInputs = [ extra-cmake-modules kdoctools ];
  propagatedBuildInputs = [
    akonadi akonadi-mime kcompletion kconfig kcoreaddons kmime kxmlgui libkdepim
  ];
}
