{
  kdeApp, lib, kdeWrapper,
  extra-cmake-modules, kdoctools,
  akonadi, akonadi-contacts, akonadi-mime, kcodecs, kcompletion, kconfigwidgets,
  kcontacts, kdbusaddons, kiconthemes, kimap, kio, kitemmodels, kjobwidgets,
  knewstuff, kpimtextedit, libkdepim, qtwebengine
}:
kdeApp {
  name = "pimcommon";
  meta = {
    license = with lib.licenses; [ gpl2 lgpl21 fdl12 ];
    maintainers = [ lib.maintainers.vandenoever ];
  };
  nativeBuildInputs = [ extra-cmake-modules kdoctools ];
  propagatedBuildInputs = [
    akonadi akonadi-contacts akonadi-mime kcodecs kcompletion kconfigwidgets
    kcontacts kdbusaddons kiconthemes kimap kio kitemmodels kjobwidgets
    knewstuff kpimtextedit libkdepim qtwebengine
  ];
}
