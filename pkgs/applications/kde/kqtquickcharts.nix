{
  mkDerivation,
  lib,
  extra-cmake-modules,
  qtbase,
  qtdeclarative,
}:

mkDerivation {
  pname = "kqtquickcharts";
  meta = with lib; {
    license = with licenses; [
      gpl2Plus
      lgpl21Plus
      fdl12Plus
    ];
    maintainers = [ maintainers.ttuegel ];
  };
  nativeBuildInputs = [ extra-cmake-modules ];
  propagatedBuildInputs = [
    qtbase
    qtdeclarative
  ];
}
