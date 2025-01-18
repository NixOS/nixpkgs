{
  mkDerivation,
  lib,
  extra-cmake-modules,
  kdoctools,
  kinit,
  kguiaddons,
  kwindowsystem,
}:

mkDerivation {
  pname = "kdialog";

  meta = with lib; {
    homepage = "https://apps.kde.org/kdialog/";
    description = "Display dialog boxes from shell scripts";
    license = with licenses; [
      gpl2Plus
      fdl12Plus
    ];
    maintainers = with maintainers; [ peterhoeg ];
  };

  nativeBuildInputs = [
    extra-cmake-modules
    kdoctools
  ];

  propagatedBuildInputs = [
    kinit
    kguiaddons
    kwindowsystem
  ];
}
