{
  kdeApp, lib,
  extra-cmake-modules, kdoctools, ki18n,
  akonadi-contacts, gpgme, karchive, kcodecs, kcontacts, kcoreaddons, kcrash,
  kdbusaddons, kiconthemes, kjobwidgets, kio, knotifications, kservice,
  ktextwidgets, kxmlgui, kwidgetsaddons, kwindowsystem
}:

kdeApp {
  name = "kgpg";
  nativeBuildInputs = [ extra-cmake-modules kdoctools ki18n ];
  buildInputs = [
    akonadi-contacts gpgme karchive kcodecs kcontacts kcoreaddons kcrash kdbusaddons
    kiconthemes kjobwidgets kio knotifications kservice ktextwidgets kxmlgui
    kwidgetsaddons kwindowsystem
  ];
  meta = {
    license = [ lib.licenses.gpl2 ];
    maintainers = [ lib.maintainers.ttuegel ];
  };
}
