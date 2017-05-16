{
  mkDerivation, lib,
  extra-cmake-modules, kdoctools, ki18n, wrapGAppsHook,
  akonadi-contacts, gnupg1, gpgme, karchive, kcodecs, kcontacts, kcoreaddons, kcrash,
  kdbusaddons, kiconthemes, kjobwidgets, kio, knotifications, kservice,
  ktextwidgets, kxmlgui, kwidgetsaddons, kwindowsystem
}:

mkDerivation {
  name = "kgpg";
  nativeBuildInputs = [ extra-cmake-modules kdoctools ki18n wrapGAppsHook ];
  buildInputs = [
    akonadi-contacts gnupg1 gpgme karchive kcodecs kcontacts kcoreaddons kcrash kdbusaddons
    kiconthemes kjobwidgets kio knotifications kservice ktextwidgets kxmlgui
    kwidgetsaddons kwindowsystem
  ];
  preFixup = ''
    gappsWrapperArgs+=(--suffix PATH : ${lib.makeBinPath [ gnupg1 ]})
  '';
  meta = {
    license = [ lib.licenses.gpl2 ];
    maintainers = [ lib.maintainers.ttuegel ];
  };
}
