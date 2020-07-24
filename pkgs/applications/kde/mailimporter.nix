{
  mkDerivation, lib, kdepimTeam,
  extra-cmake-modules, kdoctools,
  akonadi, akonadi-mime, karchive, kcompletion, kconfig, kcoreaddons, ki18n,
  kmime, kxmlgui, libkdepim
}:

mkDerivation {
  name = "mailimporter";
  meta = {
    license = with lib.licenses; [ gpl2 lgpl21 fdl12 ];
    maintainers = kdepimTeam;
  };
  nativeBuildInputs = [ extra-cmake-modules kdoctools ];
  buildInputs = [
    akonadi akonadi-mime karchive kcompletion kconfig kcoreaddons ki18n kmime
    kxmlgui libkdepim
  ];
}
