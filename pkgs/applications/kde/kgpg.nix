{
  mkDerivation, lib,
  extra-cmake-modules, kdoctools, ki18n, makeWrapper,
  akonadi-contacts, gnupg1, gpgme, karchive, kcodecs, kcontacts, kcoreaddons,
  kcrash, kdbusaddons, kiconthemes, kjobwidgets, kio, knotifications, kservice,
  ktextwidgets, kxmlgui, kwidgetsaddons, kwindowsystem
}:

mkDerivation {
  name = "kgpg";
  nativeBuildInputs = [ extra-cmake-modules kdoctools makeWrapper ];
  buildInputs = [ gnupg1 gpgme ki18n ];
  propagatedBuildInputs = [
    akonadi-contacts karchive kcodecs kcontacts kcoreaddons kcrash kdbusaddons
    kiconthemes kjobwidgets kio knotifications kservice ktextwidgets kxmlgui
    kwidgetsaddons kwindowsystem
  ];
  postFixup = ''
    wrapProgram "$out/bin/kgpg" --prefix PATH : "${lib.makeBinPath [ gnupg1 ]}"
  '';
  meta = {
    license = [ lib.licenses.gpl2 ];
    maintainers = [ lib.maintainers.ttuegel ];
  };
}
