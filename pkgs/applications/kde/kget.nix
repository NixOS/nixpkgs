{
  mkDerivation, lib,
  extra-cmake-modules, kdoctools,
  kdelibs4support, libgcrypt, libktorrent, qca-qt5, qgpgme,
  kcmutils, kcompletion, kcoreaddons, knotifyconfig, kparts, kwallet, kwidgetsaddons, kwindowsystem, kxmlgui
}:

mkDerivation {
  name = "kget";

  nativeBuildInputs = [ extra-cmake-modules kdoctools ];

  buildInputs = [
    kdelibs4support libgcrypt libktorrent qca-qt5 qgpgme
    kcmutils kcompletion kcoreaddons knotifyconfig kparts kwallet kwidgetsaddons kwindowsystem kxmlgui
  ];

  meta = with lib; {
    license = with licenses; [ gpl2 ];
    maintainers = with maintainers; [ peterhoeg ];
  };
}
