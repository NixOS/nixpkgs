{
  mkDerivation, lib,
  extra-cmake-modules, kdoctools,
  kinit, kguiaddons, kwindowsystem
}:

mkDerivation {
  pname = "kdialog";

  meta = {
    license = with lib.licenses; [ gpl2 fdl12 ];
    maintainers = with lib.maintainers; [ peterhoeg ];
  };

  nativeBuildInputs = [ extra-cmake-modules kdoctools ];

  propagatedBuildInputs = [ kinit kguiaddons kwindowsystem ];
}
