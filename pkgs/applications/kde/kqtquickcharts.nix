{
  mkDerivation,
  lib,
  extra-cmake-modules,
  qtbase,
  qtdeclarative,
}:

mkDerivation {
  pname = "kqtquickcharts";
  meta = {
    license = with lib.licenses; [
      gpl2Plus
      lgpl21Plus
      fdl12Plus
    ];
    maintainers = [ lib.maintainers.ttuegel ];
  };
  nativeBuildInputs = [ extra-cmake-modules ];
  propagatedBuildInputs = [
    qtbase
    qtdeclarative
  ];
}
