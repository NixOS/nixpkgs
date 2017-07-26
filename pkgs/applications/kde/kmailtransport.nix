{
  kdeApp, lib,
  extra-cmake-modules, kdoctools,
  akonadi, akonadi-mime, cyrus_sasl, kcmutils, kmime
}:
kdeApp {
  name = "kmailtransport";
  meta = {
    license = with lib.licenses; [ gpl2 lgpl21 fdl12 ];
    maintainers = [ lib.maintainers.vandenoever ];
  };
  nativeBuildInputs = [ extra-cmake-modules kdoctools ];
  propagatedBuildInputs = [
    akonadi akonadi-mime cyrus_sasl kcmutils kmime
  ];
}
