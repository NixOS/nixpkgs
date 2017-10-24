{ mkDerivation
, lib, extra-cmake-modules
, drumstick, fluidsynth
, kcoreaddons, kcrash, kdoctools
, qtquickcontrols2, qtsvg, qttools
}:

mkDerivation {
  name = "minuet";
  meta = with lib; {
    license = with licenses; [ lgpl21 gpl3 ];
    maintainers = with maintainers; [ peterhoeg ];
  };

  nativeBuildInputs = [ extra-cmake-modules kdoctools ];
  propagatedBuildInputs = [
    drumstick fluidsynth
    kcoreaddons kcrash
    qtquickcontrols2 qtsvg qttools
  ];
  enableParallelBuilding = true;
}
