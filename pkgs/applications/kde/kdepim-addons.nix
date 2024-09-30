{
  mkDerivation, lib, kdepimTeam,
  extra-cmake-modules, shared-mime-info,
  akonadi-import-wizard, akonadi-notes, calendarsupport, eventviews,
  incidenceeditor, kcalendarcore, kcalutils, kconfig, kdbusaddons, kdeclarative,
  kholidays, ki18n, kmime, ktexteditor, ktnef, libgravatar,
  libksieve, mailcommon, mailimporter, messagelib, poppler, prison, kpkpass,
  kitinerary, kontactinterface, kaddressbook, discount
}:

mkDerivation {
  pname = "kdepim-addons";
  meta = {
    license = with lib.licenses; [ gpl2Plus lgpl21Plus ];
    maintainers = kdepimTeam;
  };
  nativeBuildInputs = [ extra-cmake-modules shared-mime-info ];
  buildInputs = [
    akonadi-import-wizard akonadi-notes calendarsupport eventviews
    incidenceeditor kcalendarcore kcalutils kconfig kdbusaddons kdeclarative
    kholidays ki18n kmime ktexteditor ktnef libgravatar
    libksieve mailcommon mailimporter messagelib poppler prison kpkpass
    kitinerary kontactinterface kaddressbook discount
  ];
}
