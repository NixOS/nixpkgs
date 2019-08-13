{
  mkDerivation, lib, fetchpatch,
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

  patches = [
    # This patch should be backported in 19.04.4 KDE applications
    (fetchpatch {
      url = "https://cgit.kde.org/kate.git/patch/?id=76ec8b55a86a29a90125b2ff3f512df007789cb1";
      sha256 = "1q0bkb6vl4xvh4aba1rlqii4a75pvl7vbcs4plny8lalzslnbzhj";
    })
  ];

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
