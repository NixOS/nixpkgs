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
  meta = with lib; {
    homepage = "https://apps.kde.org/kgeography/";
    description = "Geography trainer";
    mainProgram = "kgeography";
    license = with licenses; [ gpl2 ];
    maintainers = [ maintainers.globin ];
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
