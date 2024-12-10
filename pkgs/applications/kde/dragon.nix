{
  mkDerivation,
  lib,
  extra-cmake-modules,
  kdoctools,
  baloo,
  baloo-widgets,
  kactivities,
  kbookmarks,
  kcmutils,
  kcompletion,
  kconfig,
  kcoreaddons,
  kdbusaddons,
  kfilemetadata,
  ki18n,
  kiconthemes,
  kinit,
  kio,
  knewstuff,
  knotifications,
  kparts,
  ktexteditor,
  kwindowsystem,
  phonon,
  solid,
  phonon-backend-gstreamer,
}:

mkDerivation {
  pname = "dragon";
  meta = {
    homepage = "https://apps.kde.org/dragonplayer/";
    license = with lib.licenses; [
      gpl2Plus
      fdl12Plus
    ];
    description = "A simple media player for KDE";
    mainProgram = "dragon";
    maintainers = [ lib.maintainers.jonathanreeve ];
  };
  nativeBuildInputs = [
    extra-cmake-modules
    kdoctools
  ];
  propagatedBuildInputs = [
    baloo
    baloo-widgets
    kactivities
    kbookmarks
    kcmutils
    kcompletion
    kconfig
    kcoreaddons
    kdbusaddons
    kfilemetadata
    ki18n
    kiconthemes
    kinit
    kio
    knewstuff
    knotifications
    kparts
    ktexteditor
    kwindowsystem
    phonon
    solid
    phonon-backend-gstreamer
  ];
  outputs = [
    "out"
    "dev"
  ];
}
