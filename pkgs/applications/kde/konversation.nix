{
  mkDerivation,
  lib,
  extra-cmake-modules,
  kdoctools,
  kbookmarks,
  karchive,
  kconfig,
  kconfigwidgets,
  kcoreaddons,
  kcrash,
  kdbusaddons,
  kemoticons,
  kglobalaccel,
  ki18n,
  kiconthemes,
  kidletime,
  kitemviews,
  knewstuff,
  knotifications,
  knotifyconfig,
  kwindowsystem,
  kio,
  kparts,
  kwallet,
  solid,
  sonnet,
  phonon,
  qtmultimedia,
}:

mkDerivation {
  pname = "konversation";

  buildInputs = [
    kbookmarks
    karchive
    kconfig
    kconfigwidgets
    kcoreaddons
    kcrash
    kdbusaddons
    kdoctools
    kemoticons
    kglobalaccel
    ki18n
    kiconthemes
    kidletime
    kitemviews
    knewstuff
    knotifications
    knotifyconfig
    kwindowsystem
    kio
    kparts
    kwallet
    solid
    sonnet
    phonon
    qtmultimedia
  ];

  nativeBuildInputs = [
    extra-cmake-modules
    kdoctools
  ];

  meta = {
    description = "Integrated IRC client for KDE";
    mainProgram = "konversation";
    license = with lib.licenses; [ gpl2 ];
    homepage = "https://konversation.kde.org";
  };
}
