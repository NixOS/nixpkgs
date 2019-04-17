{
  mkDerivation, lib,
  extra-cmake-modules, kdoctools,
  karchive, kcoreaddons, kfilemetadata, ktextwidgets, kwidgetsaddons, kio
}:

mkDerivation {
  name = "kfind";
  meta = {
    license = with lib.licenses; [ gpl2 ];
    maintainers = [ lib.maintainers.iblech ];
  };
  nativeBuildInputs = [ extra-cmake-modules kdoctools ];
  buildInputs = [
    karchive kcoreaddons kfilemetadata ktextwidgets kwidgetsaddons kio
  ];
}
