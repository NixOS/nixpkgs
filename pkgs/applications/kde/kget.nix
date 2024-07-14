{
  mkDerivation, lib,
  extra-cmake-modules, kdoctools,
  kdelibs4support, libgcrypt, libktorrent, qca-qt5, qgpgme,
  kcmutils, kcompletion, kcoreaddons, knotifyconfig, kparts, kwallet, kwidgetsaddons, kwindowsystem, kxmlgui
}:

mkDerivation {
  pname = "kget";

  nativeBuildInputs = [ extra-cmake-modules kdoctools ];

  buildInputs = [
    kdelibs4support libgcrypt libktorrent qca-qt5 qgpgme
    kcmutils kcompletion kcoreaddons knotifyconfig kparts kwallet kwidgetsaddons kwindowsystem kxmlgui
  ];

  meta = with lib; {
    homepage = "https://apps.kde.org/kget/";
    description = "Download manager";
    mainProgram = "kget";
    license = with licenses; [ gpl2 ];
    maintainers = with maintainers; [ peterhoeg ];
  };
}
