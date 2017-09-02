{
  mkDerivation, lib, kdepimTeam,
  extra-cmake-modules, kdoctools,
  akonadi, akonadi-mime, kcalcore, kcmutils, kcontacts, kcoreaddons, kmime,
  krunner, qtbase, xapian
}:

mkDerivation {
  name = "akonadi-search";
  meta = {
    license = with lib.licenses; [ gpl2 lgpl21 fdl12 ];
    maintainers = kdepimTeam;
  };
  nativeBuildInputs = [ extra-cmake-modules kdoctools ];
  buildInputs = [ kcmutils krunner xapian ];
  propagatedBuildInputs = [
    akonadi akonadi-mime kcalcore kcontacts kcoreaddons kmime qtbase
  ];
  outputs = [ "out" "dev" ];
}
