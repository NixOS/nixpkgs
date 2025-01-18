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
  kuserfeedback,
  wayland,
  qtwayland,
  qtx11extras,
  qtimageformats,
}:

mkDerivation {
  pname = "dolphin";
  meta = with lib; {
    homepage = "https://apps.kde.org/dolphin/";
    description = "KDE file manager";
    license = with licenses; [
      gpl2Plus
      fdl12Plus
    ];
    maintainers = [ maintainers.ttuegel ];
  };
  nativeBuildInputs = [
    extra-cmake-modules
    kdoctools
  ];
  propagatedUserEnvPkgs = [ baloo ];
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
    kuserfeedback
    wayland
    qtwayland
    qtx11extras
    qtimageformats
  ];
  outputs = [
    "out"
    "dev"
  ];
}
