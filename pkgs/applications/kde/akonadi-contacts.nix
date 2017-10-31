{
  mkDerivation, lib, kdepimTeam,
  extra-cmake-modules,
  qtwebengine,
  grantlee,
  kdbusaddons, ki18n, kiconthemes, kio, kitemmodels, ktextwidgets, prison,
  akonadi, akonadi-mime, kcontacts, kmime,
}:

mkDerivation {
  name = "akonadi-contacts";
  meta = {
    license = with lib.licenses; [ gpl2 lgpl21 ];
    maintainers = kdepimTeam;
  };
  nativeBuildInputs = [ extra-cmake-modules ];
  buildInputs = [
    qtwebengine
    grantlee
    kdbusaddons ki18n kiconthemes kio kitemmodels ktextwidgets prison
    akonadi-mime kcontacts kmime
  ];
  propagatedBuildInputs = [ akonadi ];
  outputs = [ "out" "dev" ];
}
