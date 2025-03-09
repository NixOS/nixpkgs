{
  mkDerivation,
  lib,
  cmake,
  extra-cmake-modules,
  qtbase,
  kconfigwidgets,
  kxmlgui,
  kcrash,
  kdoctools,
  kitemviews,
}:

mkDerivation {
  pname = "kgeography";
  meta = {
    homepage = "https://apps.kde.org/kgeography/";
    description = "Geography trainer";
    mainProgram = "kgeography";
    license = with lib.licenses; [ gpl2 ];
    maintainers = [ lib.maintainers.globin ];
  };
  nativeBuildInputs = [
    cmake
    extra-cmake-modules
  ];
  buildInputs = [
    qtbase
    kconfigwidgets
    kxmlgui
    kcrash
    kdoctools
    kitemviews
  ];
}
