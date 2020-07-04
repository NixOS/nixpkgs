{ mkDerivation
, lib, extra-cmake-modules, gettext, python
, drumstick, fluidsynth
, kcoreaddons, kcrash, kdoctools
, qtquickcontrols2, qtsvg, qttools, qtdeclarative
}:

mkDerivation {
  name = "minuet";
  meta = with lib; {
    license = with licenses; [ lgpl21 gpl3 ];
    maintainers = with maintainers; [ peterhoeg HaoZeke ];
  };

  nativeBuildInputs = [ extra-cmake-modules gettext kdoctools python qtdeclarative ];

  propagatedBuildInputs = [
    drumstick fluidsynth
    kcoreaddons kcrash
    qtquickcontrols2 qtsvg qttools
  ];

  enableParallelBuilding = true;
}
