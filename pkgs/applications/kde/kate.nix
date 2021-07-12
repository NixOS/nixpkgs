{
  mkDerivation, lib,
  extra-cmake-modules, kdoctools,
  kactivities, kconfig, kcrash, kdbusaddons, kguiaddons, kiconthemes, ki18n,
  kinit, kio, kitemmodels, kjobwidgets, knewstuff, knotifications, konsole,
  kparts, ktexteditor, kwindowsystem, kwallet, kxmlgui, libgit2,
  plasma-framework, qtscript, threadweaver
}:

mkDerivation {
  pname = "kate";
  meta = {
    license = with lib.licenses; [ gpl3 lgpl3 lgpl2 ];
    maintainers = [ lib.maintainers.ttuegel ];
  };

  # InitialPreference values are too high and end up making kate &
  # kwrite defaults for anything considered text/plain. Resetting to
  # 1, which is the default.
  postPatch = ''
    substituteInPlace kate/data/org.kde.kate.desktop \
      --replace InitialPreference=9 InitialPreference=1
    substituteInPlace kwrite/data/org.kde.kwrite.desktop \
      --replace InitialPreference=8 InitialPreference=1
  '';

  nativeBuildInputs = [ extra-cmake-modules kdoctools ];
  buildInputs = [
    libgit2
    kactivities ki18n kio ktexteditor kwindowsystem plasma-framework
    qtscript kconfig kcrash kguiaddons kiconthemes kinit kjobwidgets kparts
    kxmlgui kdbusaddons kwallet kitemmodels knotifications threadweaver
    knewstuff
  ];
  propagatedUserEnvPkgs = [ konsole ];
}
