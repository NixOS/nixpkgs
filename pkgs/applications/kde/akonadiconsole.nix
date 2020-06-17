{
  mkDerivation, lib, kdepimTeam,
  extra-cmake-modules, kdoctools,
  akonadi, akonadi-contacts, calendarsupport, kcalendarcore, kcompletion,
  kconfigwidgets, kcontacts, kdbusaddons, kitemmodels, kpimtextedit, libkdepim,
  ktextwidgets, kxmlgui, messagelib, qtbase, akonadi-search, xapian
}:

mkDerivation {
  name = "akonadiconsole";
  meta = {
    license = with lib.licenses; [ gpl2 lgpl21 fdl12 ];
    maintainers = kdepimTeam;
  };
  nativeBuildInputs = [ extra-cmake-modules kdoctools ];
  buildInputs = [
    akonadi akonadi-contacts calendarsupport kcalendarcore kcompletion kconfigwidgets
    kcontacts kdbusaddons kitemmodels kpimtextedit ktextwidgets kxmlgui
    messagelib qtbase libkdepim akonadi-search xapian
  ];
}
