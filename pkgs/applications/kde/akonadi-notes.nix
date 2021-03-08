{
  mkDerivation, lib, kdepimTeam,
  extra-cmake-modules, kdoctools,
  akonadi, kcompletion, ki18n, kitemmodels, kmime, kxmlgui
}:

mkDerivation {
  pname = "akonadi-notes";
  meta = {
    license = with lib.licenses; [ gpl2 lgpl21 fdl12 ];
    maintainers = kdepimTeam;
  };
  nativeBuildInputs = [ extra-cmake-modules kdoctools ];
  buildInputs = [
    akonadi kcompletion ki18n kitemmodels kmime kxmlgui
  ];
  outputs = [ "out" "dev" ];
}
