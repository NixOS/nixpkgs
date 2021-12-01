{
  mkDerivation, lib, kdepimTeam,
  extra-cmake-modules,
  qtwebengine,
  grantlee, grantleetheme,
  kcmutils, kdbusaddons, ki18n, kiconthemes, kio, kitemmodels, ktextwidgets,
  prison, akonadi, akonadi-mime, kcontacts, kmime, libkleo,
}:

mkDerivation {
  pname = "akonadi-contacts";
  meta = {
    license = with lib.licenses; [ gpl2 lgpl21 ];
    maintainers = kdepimTeam;
  };
  nativeBuildInputs = [ extra-cmake-modules ];
  buildInputs = [
    qtwebengine
    grantlee grantleetheme
    kcmutils kdbusaddons ki18n kiconthemes kio kitemmodels ktextwidgets prison
    akonadi-mime kcontacts kmime libkleo
  ];
  propagatedBuildInputs = [ akonadi ];
  outputs = [ "out" "dev" ];
}
