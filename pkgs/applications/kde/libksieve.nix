{
  mkDerivation,
  lib,
  kdepimTeam,
  extra-cmake-modules,
  kdoctools,
  akonadi,
  karchive,
  kcompletion,
  kiconthemes,
  kidentitymanagement,
  kio,
  kmailtransport,
  knewstuff,
  kwindowsystem,
  kxmlgui,
  libkdepim,
  pimcommon,
  qtwebengine,
  syntax-highlighting,
}:

mkDerivation {
  pname = "libksieve";
  meta = {
    license = with lib.licenses; [
      gpl2Plus
      lgpl21Plus
      fdl12Plus
    ];
    maintainers = kdepimTeam;
  };
  outputs = [
    "out"
    "dev"
  ];
  nativeBuildInputs = [
    extra-cmake-modules
    kdoctools
  ];
  buildInputs = [
    akonadi
    karchive
    kcompletion
    kiconthemes
    kidentitymanagement
    kio
    kmailtransport
    knewstuff
    kwindowsystem
    kxmlgui
    libkdepim
    pimcommon
    qtwebengine
  ];
  propagatedBuildInputs = [ syntax-highlighting ];
}
