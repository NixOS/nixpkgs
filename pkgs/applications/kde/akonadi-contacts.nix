{
  mkDerivation, lib,
  extra-cmake-modules,
  akonadi, akonadi-mime, grantlee, kcontacts, kdbusaddons, ki18n, kiconthemes,
  kio, kitemmodels, kmime, ktextwidgets, qtwebengine,
}:

mkDerivation {
  name = "akonadi-contacts";
  meta = {
    license = with lib.licenses; [ gpl2 lgpl21 ];
    maintainers = [ lib.maintainers.ttuegel ];
  };
  nativeBuildInputs = [ extra-cmake-modules ];
  buildInputs = [
    akonadi-mime grantlee kcontacts kdbusaddons ki18n kiconthemes kio
    kitemmodels kmime ktextwidgets qtwebengine
  ];
  propagatedBuildInputs = [ akonadi ];
  outputs = [ "out" "dev" ];
}
