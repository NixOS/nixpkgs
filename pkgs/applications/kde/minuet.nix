{
  mkDerivation,
  lib,
  extra-cmake-modules,
  gettext,
  python3,
  drumstick,
  fluidsynth,
  kcoreaddons,
  kcrash,
  kdoctools,
  qtquickcontrols2,
  qtsvg,
  qttools,
  qtdeclarative,
}:

mkDerivation {
  pname = "minuet";
  meta = {
    homepage = "https://apps.kde.org/minuet/";
    description = "Music Education Software";
    mainProgram = "minuet";
    license = with lib.licenses; [
      lgpl21
      gpl3
    ];
    maintainers = with lib.maintainers; [
      peterhoeg
      HaoZeke
    ];
  };

  nativeBuildInputs = [
    extra-cmake-modules
    gettext
    kdoctools
    python3
    qtdeclarative
  ];

  propagatedBuildInputs = [
    drumstick
    fluidsynth
    kcoreaddons
    kcrash
    qtquickcontrols2
    qtsvg
    qttools
  ];

  enableParallelBuilding = true;
}
