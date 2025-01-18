{
  mkDerivation,
  lib,
  extra-cmake-modules,
  kdoctools,
  ki18n,
  makeWrapper,
  akonadi-contacts,
  gnupg,
  karchive,
  kcodecs,
  kcontacts,
  kcoreaddons,
  kcrash,
  kdbusaddons,
  kiconthemes,
  kjobwidgets,
  kio,
  knotifications,
  kservice,
  ktextwidgets,
  kxmlgui,
  kwidgetsaddons,
  kwindowsystem,
  qgpgme,
}:

mkDerivation {
  pname = "kgpg";
  nativeBuildInputs = [
    extra-cmake-modules
    kdoctools
    makeWrapper
  ];
  buildInputs = [
    akonadi-contacts
    gnupg
    karchive
    kcodecs
    kcontacts
    kcoreaddons
    kcrash
    kdbusaddons
    ki18n
    kiconthemes
    kjobwidgets
    kio
    knotifications
    kservice
    ktextwidgets
    kxmlgui
    kwidgetsaddons
    kwindowsystem
    qgpgme
  ];
  postFixup = ''
    wrapProgram "$out/bin/kgpg" --prefix PATH : "${lib.makeBinPath [ gnupg ]}"
  '';
  meta = with lib; {
    homepage = "https://apps.kde.org/kgpg/";
    description = "KDE based interface for GnuPG, a powerful encryption utility";
    mainProgram = "kgpg";
    license = [ licenses.gpl2 ];
    maintainers = [ maintainers.ttuegel ];
  };
}
