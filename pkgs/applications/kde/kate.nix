{
  mkDerivation, lib,
  extra-cmake-modules, kdoctools,
  kactivities, kconfig, kcrash, kdbusaddons, kguiaddons, kiconthemes, ki18n,
  kinit, kio, kitemmodels, kjobwidgets, knewstuff, knotifications, konsole,
  kparts, ktexteditor, kwindowsystem, kwallet, kxmlgui, libgit2,
  kuserfeedback, plasma-framework, qtscript, threadweaver, qtx11extras
}:

mkDerivation {
  pname = "kate";
  meta = {
    homepage = "https://apps.kde.org/kate/";
    description = "Advanced text editor";
    license = with lib.licenses; [ gpl3 lgpl3 lgpl2 ];
    maintainers = [ lib.maintainers.ttuegel ];
  };

  # InitialPreference values are too high and end up making kate &
  # kwrite defaults for anything considered text/plain. Resetting to
  # 1, which is the default.
  postPatch = ''
    substituteInPlace apps/kate/data/org.kde.kate.desktop \
      --replace InitialPreference=9 InitialPreference=1
    substituteInPlace apps/kwrite/data/org.kde.kwrite.desktop \
      --replace InitialPreference=8 InitialPreference=1
  '';

  nativeBuildInputs = [ extra-cmake-modules kdoctools ];
  buildInputs = [
    libgit2
    kactivities ki18n kio ktexteditor kwindowsystem plasma-framework
    qtscript kconfig kcrash kguiaddons kiconthemes kinit kjobwidgets kparts
    kxmlgui kdbusaddons kwallet kitemmodels knotifications threadweaver
    knewstuff kuserfeedback qtx11extras
  ];
  propagatedUserEnvPkgs = [ konsole ];
}
