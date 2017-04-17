{
  kdeApp, lib,
  extra-cmake-modules, kdoctools,
  akonadi, akonadi-mime, kcodecs, kcompletion, kconfigwidgets, kiconthemes, kio,
  kitemmodels, kldap, kmailtransport, mailimporter, messagelib
}:
kdeApp {
  name = "mailcommon";
  meta = {
    license = with lib.licenses; [ gpl2 lgpl21 fdl12 ];
    maintainers = [ lib.maintainers.vandenoever ];
  };
  nativeBuildInputs = [ extra-cmake-modules kdoctools ];
  propagatedBuildInputs = [
    akonadi akonadi-mime kcodecs kcompletion kconfigwidgets kiconthemes kio
    kitemmodels kldap kmailtransport mailimporter messagelib
  ];
}
