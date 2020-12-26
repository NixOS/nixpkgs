{
  mkDerivation, lib,
  extra-cmake-modules,
  qtbase, qtdeclarative,
}:

mkDerivation {
  pname = "kqtquickcharts";
  meta = {
    license = with lib.licenses; [ gpl2 lgpl21 fdl12 ];
    maintainers = [ lib.maintainers.ttuegel ];
  };
  nativeBuildInputs = [ extra-cmake-modules ];
  propagatedBuildInputs = [ qtbase qtdeclarative ];
}
