{
  mkDerivation, lib, kdepimTeam,
  extra-cmake-modules, kdoctools,
  akonadi, akonadi-search, kconfig, kservice, kio, mailcommon, mailimporter, messagelib
}:

mkDerivation {
  name = "mbox-importer";
  meta = {
    license = with lib.licenses; [ gpl2 lgpl21 fdl12 ];
    maintainers = kdepimTeam;
  };
  nativeBuildInputs = [ extra-cmake-modules kdoctools ];
  buildInputs = [
    akonadi akonadi-search kconfig kservice kio mailcommon mailimporter messagelib
  ];
}
