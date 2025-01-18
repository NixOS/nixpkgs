{
  mkDerivation,
  lib,
  extra-cmake-modules,
  kdoctools,
  karchive,
  kcoreaddons,
  kfilemetadata,
  ktextwidgets,
  kwidgetsaddons,
  kio,
}:

mkDerivation {
  pname = "kfind";
  meta = with lib; {
    homepage = "https://apps.kde.org/kfind/";
    description = "Find files/folders";
    mainProgram = "kfind";
    license = with licenses; [ gpl2 ];
    maintainers = [ maintainers.iblech ];
  };
  nativeBuildInputs = [
    extra-cmake-modules
    kdoctools
  ];
  buildInputs = [
    karchive
    kcoreaddons
    kfilemetadata
    ktextwidgets
    kwidgetsaddons
    kio
  ];
}
