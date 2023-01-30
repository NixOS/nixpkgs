{
  mkDerivation, lib, kdepimTeam,
  extra-cmake-modules, kdoctools,
  akonadi, kcompletion, ki18n, kitemmodels, kmime, kxmlgui
}:

mkDerivation {
  pname = "akonadi-notes";
  meta = {
    license = with lib.licenses; [ gpl2Plus lgpl21Plus fdl12Plus ];
    maintainers = kdepimTeam;
  };
  nativeBuildInputs = [ extra-cmake-modules kdoctools ];
  buildInputs = [
    akonadi kcompletion ki18n kitemmodels kmime kxmlgui
  ];
  outputs = [ "out" "dev" ];
}
