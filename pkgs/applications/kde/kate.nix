{
  mkDerivation, lib,
  extra-cmake-modules, kdoctools,
  kactivities, kconfig, kcrash, kdbusaddons, kguiaddons, kiconthemes, ki18n,
  kinit, kio, kitemmodels, kjobwidgets, knewstuff, knotifications, konsole,
  kparts, ktexteditor, kwindowsystem, kwallet, kxmlgui, libgit2,
  plasma-framework, qtscript, threadweaver
}:

mkDerivation {
  name = "kate";
  meta = {
    license = with lib.licenses; [ gpl3 lgpl3 lgpl2 ];
    maintainers = [ lib.maintainers.ttuegel ];
  };
  nativeBuildInputs = [ extra-cmake-modules kdoctools ];
  buildInputs = [ libgit2 ];
  propagatedBuildInputs = [
    kactivities ki18n kio ktexteditor kwindowsystem plasma-framework
    qtscript kconfig kcrash kguiaddons kiconthemes kinit kjobwidgets kparts
    kxmlgui kdbusaddons kwallet kitemmodels knotifications threadweaver
    knewstuff
  ];
  propagatedUserEnvPkgs = [ konsole ];
}
